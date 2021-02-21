import 'dart:io';
import 'dart:async';

void main() {
  print("Main()");
  runZoned(() {
    print("Running zoned");
    test();
  }, onError: (Object e, StackTrace st) {
    print("zone error $e, stack trace: $st");
  });
}

Future<void> test() async {
  try {
    ServerSocket server =
        await ServerSocket.bind(InternetAddress.anyIPv4, 9000);
    List<List<int>> players = [];
    List<Socket> sockets = [];
    server.listen((Socket socket) {
      sockets.add(socket);
      print("Got socket.");
      socket.listen((List<int> message) {
        if(message[0] >= players.length) {
          players.add([0, 0]);
        }
        switch(message[1]) {
          case 1:
            if(players[message[0]][0] < 9)
            players[message[0]][0]++;
            break;
          case 2:
            if(players[message[0]][0] > 0)
            players[message[0]][0]--;
            break;
          case 3:
            if(players[message[0]][1] < 9)
            players[message[0]][1]++;
            break;
          case 4:
            if(players[message[0]][1] > 0)
            players[message[0]][1]--;
            break;
        }
        print(players);
        for(Socket socket in sockets)
        socket.add([0, 0, 0, 0, 0, 0, 0, (players.length*2)+2, 10, 10] + players.expand((x) => x).toList());
      }, onError: (Object e, StackTrace st) {
        print("error: $e\nstack\n$st");
      }, cancelOnError: true);
    }, onDone: () {
      print("external done");
    }, onError: (Object e, StackTrace st) {
      print("oerror: $e, stack trace: $st");
    });
    print(".listened");
  } catch (e, st) {
    print("eerror: $e, stack trace: $st");
  }
}
