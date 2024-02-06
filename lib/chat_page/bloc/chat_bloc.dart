import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:kwentokape/constants/constants.dart';
import 'package:kwentokape/models/chatmodel.dart';
import 'package:uuid/uuid.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference rooms =
      FirebaseFirestore.instance.collection('rooms');

  ChatBloc() : super(ChatState.initial()) {
    on<ChatEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<CreateUser>(_createUser);
    on<ListenToUserInfo>(_listenToUserInfo);
    on<FindStranger>(_findStranger);
    on<AddInterest>(_addInterest);
    on<RemoveInterest>(_removeInterest);
    on<FindRoom>(_findRoom);
    on<SendMessage>(_sendMessage);
    on<GetMessage>(_getMessage);
  }

  FutureOr<void> _createUser(CreateUser event, Emitter<ChatState> emit) async {
    // String id = FirebaseFirestore.instance.collection('users').doc().id;

    await users.doc(state.uuid).set(<String, dynamic>{
      'uuid': state.uuid,
      'interests': state.interests,
    }).then((value) => add(const ListenToUserInfo()));
  }

  FutureOr<void> _listenToUserInfo(
      ListenToUserInfo event, Emitter<ChatState> emit) {
    if (state.userSubscription != null) {
      state.userSubscription!.cancel();
    }
    var subscription =
        users.doc(state.uuid).snapshots().listen((snapshot) async {
      if (snapshot.data() == null) {
        add(const FindRoom());
        state.userSubscription!.cancel();
      }
    });

    emit(state.copyWith(
      userSubscription: subscription,
      dateTime: DateTime.now(),
    ));

    add(const FindStranger());
  }

  FutureOr<void> _findStranger(
      FindStranger event, Emitter<ChatState> emit) async {
    do {
      var currentUser = await users.doc(state.uuid).get();

      if (currentUser.data() == null) {
        //FOUND A MATCH!
        break;
      }

      QuerySnapshot<Object?> interestsQuery;

      if (state.interests.isEmpty) {
        interestsQuery = await users
            .where('interests', isEqualTo: [])
            .where("uuid", isNotEqualTo: state.uuid)
            .limit(1)
            .get();
      } else {
        interestsQuery = await users
            .where('interests', arrayContainsAny: state.interests)
            .where("uuid", isNotEqualTo: state.uuid)
            .limit(1)
            .get();
      }

      if (interestsQuery.docs.isEmpty) {
        emit(state.copyWith(status: Status.looking));
        await Future.delayed(const Duration(milliseconds: 500), () {});
      } else {
        // FOUND A MATCH!

        await users.doc(state.uuid).delete();
        await users.doc(interestsQuery.docs.first.id).delete();

        // CREATE ROOM
        var commonInterests = state.interests
            .where((element) =>
                interestsQuery.docs.first.get('interests').contains(element))
            .toList();

        await rooms.doc().set(<String, dynamic>{
          'uuids': [state.uuid, interestsQuery.docs.first.id],
          'interests': commonInterests,
        });

        // emit(state.copyWith(status: Status.chatting));
        break;
      }
    } while (true);
  }

  FutureOr<void> _addInterest(AddInterest event, Emitter<ChatState> emit) {
    state.interests.add(event.interest);
    emit(state.copyWith(dateTime: DateTime.now()));
  }

  FutureOr<void> _removeInterest(
      RemoveInterest event, Emitter<ChatState> emit) {
    state.interests.removeAt(event.index);
    emit(state.copyWith(dateTime: DateTime.now()));
  }

  FutureOr<void> _findRoom(FindRoom event, Emitter<ChatState> emit) async {
    if (state.roomSubscription != null) {
      state.roomSubscription!.cancel();
    }

    if (state.messageSubscription != null) {
      state.messageSubscription!.cancel();
    }

    // var roomId = await rooms.where('uuids', arrayContains: state.uuid).firestore.collection(collectionPath).doc()
    bool retry = false;
    do {
      try {
        String roomId = '';
        var query = rooms.where('uuids', arrayContains: state.uuid);

        var roomSubscription = query.limit(1).snapshots().listen((snapshot) {
          if (snapshot.docs.isEmpty || snapshot.docs.first.data() == null) {
            // NO ROOM FOUND
          }
          roomId = snapshot.docs.first.id;
        });

        final querySnapshot = await query.get();

        final documentSnapshot = querySnapshot.docs.first;

        final subcollectionRef =
            rooms.doc(documentSnapshot.id).collection('messages');

        var messageSubscription = subcollectionRef
            .orderBy("created")
            .limitToLast(5)
            .snapshots()
            .listen((querySnapshot) {
          if (querySnapshot.docs.isEmpty) {
            // NO MESSAGES FOUND
          } else {
            add(GetMessage(
                message: (MessageModel(
              id: querySnapshot.docs.last.id,
              uuid: querySnapshot.docs.last.get('uuid'),
              message: querySnapshot.docs.last.get('message'),
              created: (querySnapshot.docs.last.get('created') as Timestamp)
                  .toDate(),
            ))));
          }
        });

        emit(state.copyWith(
          roomSubscription: roomSubscription,
          messageSubscription: messageSubscription,
          dateTime: DateTime.now(),
          status: Status.chatting,
          roomId: roomId,
        ));

        retry = false;
      } catch (ex) {
        print(ex);
        retry = true;
      }
    } while (retry);
  }

  FutureOr<void> _sendMessage(
      SendMessage event, Emitter<ChatState> emit) async {
    await rooms
        .doc(state.roomId)
        .collection("messages")
        .doc()
        .set(<String, dynamic>{
      "uuid": state.uuid,
      "message": event.message,
      "created": DateTime.now()
    });
  }

  FutureOr<void> _getMessage(GetMessage event, Emitter<ChatState> emit) {
    state.messages.add(event.message);
    emit(state.copyWith(dateTime: DateTime.now()));
  }
}
