import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;

class Storage {
  //final FirebaseAuth _auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase.instance.reference();

  Future upImage(String img, var vimg, String pdid, String nam) async {
    String name = nam + "." + img.split(".").last;
    StorageReference storageRefernce = FirebaseStorage.instance
        .ref()
        .child("Image_Product")
        .child(pdid.toString())
        .child(name);
    StorageUploadTask uploadTask = storageRefernce.putFile(vimg);
    var dowloadurl = await (await uploadTask.onComplete).ref.getDownloadURL();
    String url = dowloadurl.toString();
    return url;
  }

  Future addProductData(
      String img1,
      String img2,
      String img3,
      var vimg1,
      var vimg2,
      var vimg3,
      String pdname,
      String pdsizeS,
      String pdsizeM,
      String pdsizeL,
      String pdsizeXL,
      String type) async {
    String key = databaseReference.child("Products").push().key;
    String url1 = await upImage(img1, vimg1, key, pdname + "(1)");
    String url2 = await upImage(img2, vimg2, key, pdname + "(2)");
    String url3 = await upImage(img3, vimg3, key, pdname + "(3)");

    databaseReference.child("Products").child(key).set({
      'id': key,
      'name': pdname,
      'sizeS': pdsizeS,
      'sizeM': pdsizeM,
      'sizeL': pdsizeL,
      'sizeXL': pdsizeXL,
      'image1': url1,
      'image2': url2,
      'image3': url3,
      'type': type
    });
  }

  Future updateBlockid(String cartid, String orderid, blockid) async {
    databaseReference
        .child("Carts")
        .child(cartid)
        .child("Orders")
        .child(orderid)
        .update({'blockid': blockid});
  }

  Future updateCartStatus(String cartid, String status) async {
    databaseReference.child("Carts").child(cartid).update({
      'status': status,
    });
  }

  Future updateSendid(String cartid, String sendid) async {
    databaseReference.child("Carts").child(cartid).update({
      'sendid': sendid,
    });
  }

  Future updateSkin(
      String cando, String skinid, double price, String becrouse) async {
    databaseReference.child("Skins").child(skinid).update({
      'cando': "yes",
      'price': price,
      'status': "ทางร้านตอบกลับแล้ว",
      'becrouse': becrouse
    });
  }

  Future createLogo(
      String detail,
      String firstname,
      String firstnameEN,
      String lastname,
      String lastnameEN,
      String name,
      String nickname,
      double price,
      String studentid,
      String type,
      String userid,
      var vimg,
      String img) async {
    String imgname = name + "." + img.split(".").last;
    StorageReference storageRefernce =
        FirebaseStorage.instance.ref().child("Image_Logo").child(imgname);
    StorageUploadTask uploadTask = storageRefernce.putFile(vimg);
    var dowloadurl = await (await uploadTask.onComplete).ref.getDownloadURL();
    String url = dowloadurl.toString();
    String logoid = databaseReference.child("Logo").push().key;
    databaseReference.child("Logo").child(logoid).set({
      'id': logoid,
      'detail': detail,
      'firstname': firstname,
      'firstnameEN': firstnameEN,
      'lastname': lastname,
      'lastnameEN': lastnameEN,
      'name': name,
      'nickname': nickname,
      'price': price,
      'studentid': studentid,
      'type': type,
      'url': url,
      'userid': userid
    });
  }

  Future updateSkinStatus(String skinid, String status) async {
    databaseReference.child("Skins").child(skinid).update({'status': status});
  }

  Future updateStatusProduct(String id,String status) async {
    /*var url1 = Uri.decodeFull(Path.basename(img1))
        .replaceAll(new RegExp(r'(\?alt).*'), '');
    var url2 = Uri.decodeFull(Path.basename(img2))
        .replaceAll(new RegExp(r'(\?alt).*'), '');
    var url3 = Uri.decodeFull(Path.basename(img3))
        .replaceAll(new RegExp(r'(\?alt).*'), '');
    StorageReference storageRefernce = FirebaseStorage.instance.ref();
    storageRefernce.child(url1).delete();
    storageRefernce.child(url2).delete();
    storageRefernce.child(url3).delete();*/
    databaseReference.child("Products").child(id).update({
      'status':status
    });
  }

  Future delLogo(String id, String img) async {
    var url1 = Uri.decodeFull(Path.basename(img))
        .replaceAll(new RegExp(r'(\?alt).*'), '');
    StorageReference storageRefernce = FirebaseStorage.instance.ref();
    storageRefernce.child(url1).delete();
    databaseReference.child("Logo").child(id).remove();
  }
}
