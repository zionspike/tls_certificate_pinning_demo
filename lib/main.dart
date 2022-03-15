import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/adapter.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
     return MaterialApp(
         home: Home()
      );
  }
}

class Home extends  StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Response response;
  Dio dio = Dio();

  bool error = false; 
  bool loading = false; 
  String errmsg = ""; 
  var apidata; 
  
  @override
  void initState() {
    getData(); 
    super.initState();
  }

  getData() async { 

    BaseOptions options = BaseOptions(
        baseUrl: "https://httpbin.org",
        connectTimeout: 3000,
        receiveTimeout: 3000,
      );

      Dio dio = Dio(options);

      // https://httpbin.org/ - leaf cert. 
      String certificate = '''
-----BEGIN CERTIFICATE-----
MIIF3DCCBMSgAwIBAgIQAVjzCtWdYq8gnxXuT8K7MzANBgkqhkiG9w0BAQsFADBG
MQswCQYDVQQGEwJVUzEPMA0GA1UEChMGQW1hem9uMRUwEwYDVQQLEwxTZXJ2ZXIg
Q0EgMUIxDzANBgNVBAMTBkFtYXpvbjAeFw0yMTExMjEwMDAwMDBaFw0yMjEyMTky
MzU5NTlaMBYxFDASBgNVBAMTC2h0dHBiaW4ub3JnMIIBIjANBgkqhkiG9w0BAQEF
AAOCAQ8AMIIBCgKCAQEAhOQnpezrwA0vHzf47Pa+O84fWue/562TqQrVirtf+3fs
GQd3MmwnId+ksAGQvWN4M1/hSelYJb246pFqGB7t+ZI+vjBYH4/J6CiFsKwzusqk
SF63ftQh8Ox0OasB9HvRlOPHT/B5Dskh8HNiJ+1lExSZEaO9zsQ9wO62bsGHsMX/
UP3VQByXLVBZu0DMKsl2hGaUNy9+LgZv4/iVpWDPQ1+khpfxP9x1H+mMlUWBgYPq
7jG5ceTbltIoF/sUQPNR+yKIBSnuiISXFHO9HEnk5ph610hWmVQKIrCAPsAUMM9m
6+iDb64NjrMjWV/bkm36r+FBMz9L8HfEB4hxlwwg5QIDAQABo4IC9DCCAvAwHwYD
VR0jBBgwFoAUWaRmBlKge5WSPKOUByeWdFv5PdAwHQYDVR0OBBYEFM8HhLgDSKzJ
rNsRZQp9Kf/Wl0uzMCUGA1UdEQQeMByCC2h0dHBiaW4ub3Jngg0qLmh0dHBiaW4u
b3JnMA4GA1UdDwEB/wQEAwIFoDAdBgNVHSUEFjAUBggrBgEFBQcDAQYIKwYBBQUH
AwIwPQYDVR0fBDYwNDAyoDCgLoYsaHR0cDovL2NybC5zY2ExYi5hbWF6b250cnVz
dC5jb20vc2NhMWItMS5jcmwwEwYDVR0gBAwwCjAIBgZngQwBAgEwdQYIKwYBBQUH
AQEEaTBnMC0GCCsGAQUFBzABhiFodHRwOi8vb2NzcC5zY2ExYi5hbWF6b250cnVz
dC5jb20wNgYIKwYBBQUHMAKGKmh0dHA6Ly9jcnQuc2NhMWIuYW1hem9udHJ1c3Qu
Y29tL3NjYTFiLmNydDAMBgNVHRMBAf8EAjAAMIIBfQYKKwYBBAHWeQIEAgSCAW0E
ggFpAWcAdgApeb7wnjk5IfBWc59jpXflvld9nGAK+PlNXSZcJV3HhAAAAX1Acwi1
AAAEAwBHMEUCIF3Y8cwUmZ9cmYSclNrSYOhYDeCzSTAYHwpIhp6oAHKBAiEA/8nK
wN0G3SwUiS3/NdzlVuuakr4a7oviAzN7zXiSmzcAdgBRo7D1/QF5nFZtuDd4jwyk
eswbJ8v3nohCmg3+1IsF5QAAAX1AcwjJAAAEAwBHMEUCIH4pZ7551jQOJ/lV20sD
KNCWOLdt+cS2pjUIFEpI8nwlAiEAj2hxpivIPtX9tReEcJCaAuC5Gh90mZz9lWQy
usID0VQAdQDfpV6raIJPH2yt7rhfTj5a6s2iEqRqXo47EsAgRFwqcwAAAX1Acwii
AAAEAwBGMEQCIEyeaMOsy5LSsKkIod2CfBML3J/+CwjvJekdMBI4QYI2AiAYKdpD
ptDftXG7GSOz8SgpqRtUoWIHs1woSj7uwEJwuzANBgkqhkiG9w0BAQsFAAOCAQEA
L2Qd0308BkF7ahyUYJkxkrfr4WyyrO7SW/TsNpSmxqPF+D/QqQcBt8tPHWg1oNEc
UYinl5qtA4kyHqpAlgzYl04FUpShkNDjcwd1GikgmNMIhSGx3EHaQeyHvrKIgCRe
TK1fPPxDvFU2ao9nnEfiQ0OossRVC6EaJsQ+/CEnTir0BEPjWRjW2C/g9YOHRyP9
PO4R/58KOy8pdJZwWkOyGKylZemsLy6sR8h3UE0KW0TawMwGO+sjWU2eB/uOJ6Yc
aAS0og1S7NrLDqT3HUWSf81g7qlNeC3hNgI8fMxFLPTkhn8+v220SJipi6ignkJR
VFoC1aTFolXMq/oMqRqUHA==
-----END CERTIFICATE-----
''';
      
      // https://www.mozilla.org - leaf cert. 
//       String certificate = '''
// -----BEGIN CERTIFICATE-----
// MIIF/jCCBOagAwIBAgIQDILsgrbhj3IiPCzDyrMk0TANBgkqhkiG9w0BAQsFADBG
// MQswCQYDVQQGEwJVUzEPMA0GA1UEChMGQW1hem9uMRUwEwYDVQQLEwxTZXJ2ZXIg
// Q0EgMUIxDzANBgNVBAMTBkFtYXpvbjAeFw0yMTEwMjIwMDAwMDBaFw0yMjExMjAy
// MzU5NTlaMB8xHTAbBgNVBAMTFHd3dy5tb3pvcmcubW96LndvcmtzMIIBIjANBgkq
// hkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEArlpi/k5o2/H4ksijD4xymuslMHkdfptb
// WY0+eXUTLaASDbsEyiXDOUDmgC49/NdnO9ATd1RCrwDPlSSBKTbCrQ2lZ+K6/RgU
// aVqyEF1nj0dG0SlnsdK82iyOK2m48fzzalRXV2EJ+s8Iw2g9X5WG5ljBDYPn4tzT
// bRreCXtjS674mOuOpip1RvzPHNQ03s83nVLLHRJ+LPp4M4vzCLQDkCBQOQtvr6wM
// SizxUndJfoyvw7SXT+zYr2VYReyy0XZAtqr/7fmxClxr214xTNPTrmYEkviS2o+9
// 6fMbTljVvu6BeYKkWUPIz4kq69/XJMntLjvqAt5vn4otSjqhwfFPvwIDAQABo4ID
// DTCCAwkwHwYDVR0jBBgwFoAUWaRmBlKge5WSPKOUByeWdFv5PdAwHQYDVR0OBBYE
// FDAVwTj4GUmGlQii1iUFYntJeOG2MD0GA1UdEQQ2MDSCFHd3dy5tb3pvcmcubW96
// Lndvcmtzgg93d3cubW96aWxsYS5vcmeCC21vemlsbGEub3JnMA4GA1UdDwEB/wQE
// AwIFoDAdBgNVHSUEFjAUBggrBgEFBQcDAQYIKwYBBQUHAwIwPQYDVR0fBDYwNDAy
// oDCgLoYsaHR0cDovL2NybC5zY2ExYi5hbWF6b250cnVzdC5jb20vc2NhMWItMS5j
// cmwwEwYDVR0gBAwwCjAIBgZngQwBAgEwdQYIKwYBBQUHAQEEaTBnMC0GCCsGAQUF
// BzABhiFodHRwOi8vb2NzcC5zY2ExYi5hbWF6b250cnVzdC5jb20wNgYIKwYBBQUH
// MAKGKmh0dHA6Ly9jcnQuc2NhMWIuYW1hem9udHJ1c3QuY29tL3NjYTFiLmNydDAM
// BgNVHRMBAf8EAjAAMIIBfgYKKwYBBAHWeQIEAgSCAW4EggFqAWgAdgApeb7wnjk5
// IfBWc59jpXflvld9nGAK+PlNXSZcJV3HhAAAAXyp2D/KAAAEAwBHMEUCIQDtvH0g
// v6gKS2W8l2zEZAY/IENY6afMxOa481DnGQj4dQIgLGh+BRzjaSxTzSbWmDktx4Cy
// z3hB+IBYFKvDyhCG6RwAdQBByMqx3yJGShDGoToJQodeTjGLGwPr60vHaPCQYpYG
// 9gAAAXyp2EAMAAAEAwBGMEQCIEIdm6VfN4TcyzALk+sbYy+8B6NSzAuVMFPEfaf7
// 2Tn9AiAKeI6wIM6+6zDdpjGXmWUxGmf21BKJGN3iz9nDNY2NqQB3AN+lXqtogk8f
// bK3uuF9OPlrqzaISpGpejjsSwCBEXCpzAAABfKnYQAUAAAQDAEgwRgIhAOM//YWg
// xKaC02MjMmK4izFlGR+3j+76XyBBNHvgdNRcAiEAnDzWCOu92RELYQBh8xJIfGuK
// ico9l10ngD/CTej0VGEwDQYJKoZIhvcNAQELBQADggEBAJWA1/gq0VqQ+bGiNHuy
// hLv/HpaL7Y3/0cZszt+PC+/KD0fAxFJ8C4v37RxAncjsPdH92FwA1q/zG7fh9I7A
// nrd6YejyUI6U7ZCtDZGcPEdSSUzesO8avDu/olShwb6x//qx2lzXPPnnimcHepVH
// Dekw+IbvhCyhJvqviSgS1Fg4pN4PlZIUY45xcVeJM3ALyRP2RAm5a8PTBbWmg7+f
// F59BF0YWmlRnnU9n+ioXerEC2jP0m9KW+k8apHr+R2FxErTrYIUFsy6LeegbeqaX
// hnwMopFg5CJA0zoFXTZDGTVPJyhfVQdezsrCYfJNs7hxu4r62ZePZ9h9sOjDxqzw
// ktE=
// -----END CERTIFICATE-----
// ''';
      
//       // Burp CA cert
//       String certificate = '''
// -----BEGIN CERTIFICATE-----
// MIIDpzCCAo+gAwIBAgIEIknL7TANBgkqhkiG9w0BAQsFADCBijEUMBIGA1UEBhML
// UG9ydFN3aWdnZXIxFDASBgNVBAgTC1BvcnRTd2lnZ2VyMRQwEgYDVQQHEwtQb3J0
// U3dpZ2dlcjEUMBIGA1UEChMLUG9ydFN3aWdnZXIxFzAVBgNVBAsTDlBvcnRTd2ln
// Z2VyIENBMRcwFQYDVQQDEw5Qb3J0U3dpZ2dlciBDQTAeFw0xNDA1MDQxMDM5NTBa
// Fw0zMTA1MDQxMDM5NTBaMIGKMRQwEgYDVQQGEwtQb3J0U3dpZ2dlcjEUMBIGA1UE
// CBMLUG9ydFN3aWdnZXIxFDASBgNVBAcTC1BvcnRTd2lnZ2VyMRQwEgYDVQQKEwtQ
// b3J0U3dpZ2dlcjEXMBUGA1UECxMOUG9ydFN3aWdnZXIgQ0ExFzAVBgNVBAMTDlBv
// cnRTd2lnZ2VyIENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAlsCL
// 5cAzJVt2A4UPnk4r1JmbwxyNnbWIgYbRpExa1aZFyHhC+0AFetylfHhQf1tEnZ5e
// Se6rE6Z007BDqpHkpvBprUFEhNvN3K+f1XmQC/UcvFvqnFGH0snaM/Q619CmLwO/
// 0jUjwNqgx410QOe0PPuew7BT6pjwwWKxLkEvsG+x3upxovcEJsasRnqXZE6vtzLX
// xxlErpzMyZ1uHzumW2WiTqAoqC+GLmfPQHMeLJ6gQniODag2aDXJ9+e+MOD100ab
// NY+PeDmOqc09bh5z5trRxc3RtFO0TNWz7T6zsX6sb7QDC3b+LlxLAPczy3v8v/ed
// KBP6d2J+kfXZcJYPYQIDAQABoxMwETAPBgNVHRMBAf8EBTADAQH/MA0GCSqGSIb3
// DQEBCwUAA4IBAQBkYrorXVLzjkqf2qg+0H5tqwWZOa/mbIYikrhbKt4Y8BVFU/Mn
// fBzeDxnAR6NPGDfV04knvQnWiivwMscqmvv72+mJKXqsQwBucjD0o+dW0SNJdqsu
// iM3EInlaI3K4mpnrJaCjwtjHHiherhBuZhB4zd+4H1vUdm55oG+RhITOLqI+8Tnk
// REWBcwQhdZa1H7AifagXIcwi8+yLSUVMyHHLu8UPiwoQWr452jLqUnlbb6nq5XzZ
// X22xuRT/e/ccvvy2V06UWpS3VpZtHLPxQYNwHnh92nKZhWasBds7nZnqsc1sX4mB
// fQAKjG+pH20+ZIHL7Od//Xy1Pf/4gMlvavBW
// -----END CERTIFICATE-----
// ''';

//       // https://www.example.com - via Burp
//       String certificate = '''
// -----BEGIN CERTIFICATE-----
// MIIDmzCCAoOgAwIBAgIEfZTybDANBgkqhkiG9w0BAQsFADCBijEUMBIGA1UEBhML
// UG9ydFN3aWdnZXIxFDASBgNVBAgTC1BvcnRTd2lnZ2VyMRQwEgYDVQQHEwtQb3J0
// U3dpZ2dlcjEUMBIGA1UEChMLUG9ydFN3aWdnZXIxFzAVBgNVBAsTDlBvcnRTd2ln
// Z2VyIENBMRcwFQYDVQQDEw5Qb3J0U3dpZ2dlciBDQTAeFw0yMjAyMjcwODM3NDNa
// Fw0yMzAyMjcwODM3NDNaMF8xFDASBgNVBAYTC1BvcnRTd2lnZ2VyMRQwEgYDVQQK
// DAtQb3J0U3dpZ2dlcjEXMBUGA1UECwwOUG9ydFN3aWdnZXIgQ0ExGDAWBgNVBAMM
// D3d3dy5leGFtcGxlLmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEB
// AJbAi+XAMyVbdgOFD55OK9SZm8McjZ21iIGG0aRMWtWmRch4QvtABXrcpXx4UH9b
// RJ2eXknuqxOmdNOwQ6qR5Kbwaa1BRITbzdyvn9V5kAv1HLxb6pxRh9LJ2jP0OtfQ
// pi8Dv9I1I8DaoMeNdEDntDz7nsOwU+qY8MFisS5BL7Bvsd7qcaL3BCbGrEZ6l2RO
// r7cy18cZRK6czMmdbh87pltlok6gKKgvhi5nz0BzHiyeoEJ4jg2oNmg1yffnvjDg
// 9dNGmzWPj3g5jqnNPW4ec+ba0cXN0bRTtEzVs+0+s7F+rG+0Awt2/i5cSwD3M8t7
// /L/3nSgT+ndifpH12XCWD2ECAwEAAaMzMDEwGgYDVR0RBBMwEYIPd3d3LmV4YW1w
// bGUuY29tMBMGA1UdJQQMMAoGCCsGAQUFBwMBMA0GCSqGSIb3DQEBCwUAA4IBAQB5
// xcIZ8RQaxYtFJjT0OsOUOsx/g5ks7nBxPbnrGQOU/qMD+OKwMqfUFKSEaVLk9kYX
// KPvN2tUcPjo2eePArZLienvuGtreBFgJGPfDwIpBzNtB+tWL0NlRojz9hhjXvHqh
// l29xIwUhsN0FElSF/ijlPkeg96I33Zx2mZKrm/en+4yj1zz4nom7l6F0o5ZHInzr
// JoF7L30gaGM203qW+0T+PWQnDwj5bgcBsuNSJSc60joM89sw5Q8CpnbQa32pcodC
// FtUNe3cb4OAqBRVIjitR262VO+Zw0l5R0+9mhX5QR/vNG7+RHg/NmW81utneJzu3
// 1ky/QRU2ag/FCAdaWCmT
// -----END CERTIFICATE-----
// ''';
//       // https://httpbin.org - via Burp
//       String certificate = '''
// -----BEGIN CERTIFICATE-----
// MIIDkzCCAnugAwIBAgIEfZTyazANBgkqhkiG9w0BAQsFADCBijEUMBIGA1UEBhML
// UG9ydFN3aWdnZXIxFDASBgNVBAgTC1BvcnRTd2lnZ2VyMRQwEgYDVQQHEwtQb3J0
// U3dpZ2dlcjEUMBIGA1UEChMLUG9ydFN3aWdnZXIxFzAVBgNVBAsTDlBvcnRTd2ln
// Z2VyIENBMRcwFQYDVQQDEw5Qb3J0U3dpZ2dlciBDQTAeFw0yMjAyMjcwODM4NTNa
// Fw0yMzAyMjcwODM4NTNaMFsxFDASBgNVBAYTC1BvcnRTd2lnZ2VyMRQwEgYDVQQK
// DAtQb3J0U3dpZ2dlcjEXMBUGA1UECwwOUG9ydFN3aWdnZXIgQ0ExFDASBgNVBAMM
// C2h0dHBiaW4ub3JnMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAlsCL
// 5cAzJVt2A4UPnk4r1JmbwxyNnbWIgYbRpExa1aZFyHhC+0AFetylfHhQf1tEnZ5e
// Se6rE6Z007BDqpHkpvBprUFEhNvN3K+f1XmQC/UcvFvqnFGH0snaM/Q619CmLwO/
// 0jUjwNqgx410QOe0PPuew7BT6pjwwWKxLkEvsG+x3upxovcEJsasRnqXZE6vtzLX
// xxlErpzMyZ1uHzumW2WiTqAoqC+GLmfPQHMeLJ6gQniODag2aDXJ9+e+MOD100ab
// NY+PeDmOqc09bh5z5trRxc3RtFO0TNWz7T6zsX6sb7QDC3b+LlxLAPczy3v8v/ed
// KBP6d2J+kfXZcJYPYQIDAQABoy8wLTAWBgNVHREEDzANggtodHRwYmluLm9yZzAT
// BgNVHSUEDDAKBggrBgEFBQcDATANBgkqhkiG9w0BAQsFAAOCAQEAHR++nqGuwLrK
// q7rihO6mWAspaMHjJilCY8v+Jitr1yEkb8iEb7pRw9rytgloQFv042fFjd3BDanf
// HZbK+tCf7jX+gCmd3agAPFxf1csw/ko+3QVyK49bG6u/mdduOJDc/Wy66s0eIOpg
// PjSDR+ANo5PozpA3Zc5hL9nWglMTb/awYyN9mEpE+/EUvudisV+07ooPi+dGXKCA
// Zdz7ZT+39iqXHwqWiDLIL4z6nM1miDPoVVtbBXTgdcyBD63NAuygzoJF2H23oJhl
// 83Pl3O8oGiixZL6YuwfABI4GkGRwM23ZSJ1NHToNoUcfdSfNayreoDvfcVVXoZZm
// B8NtHTDa3w==
// -----END CERTIFICATE-----
// ''';

      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate  = (client) {
          SecurityContext sc = new SecurityContext();
          sc.setTrustedCertificatesBytes(certificate.codeUnits);
          HttpClient httpClient = new HttpClient(context: sc);
          return httpClient;
      };


      setState(() {
         loading = true;  
      });

      String url = "https://httpbin.org";


    try {
        Response response = await dio.get(url); 
        apidata = response.data; 
        
        print(apidata); 
      } catch (e) {
        print("Exception: $e");
        errmsg = '$e';
        error = true;
      }
      
      loading = false;
      setState(() {}); 
  }

  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
         appBar: AppBar(
            title: Text("TLS Certificate Pinning Demo"),
            backgroundColor: Colors.redAccent,
         ),

         body: Container(
           alignment: Alignment.topCenter,
           padding: EdgeInsets.all(20),
            child: loading?
             CircularProgressIndicator(): 
             Container( 
               child:error?Text("Error: $errmsg"):
               Text('$apidata'),
             )       
         )
    );
  } 
}