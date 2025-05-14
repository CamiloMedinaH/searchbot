class User{
  var _uid;
  var _name;
  var _email;
  var _genre;
  var _bornDate;
  var _urlPicture;

  User(this._uid, this._name, this._email, this._genre, this._bornDate,
      this._urlPicture);

  get urlPicture => _urlPicture;

  set urlPicture(value) {
    _urlPicture = value;
  }

  get bornDate => _bornDate;

  set bornDate(value) {
    _bornDate = value;
  }

  get genre => _genre;

  set genre(value) {
    _genre = value;
  }

  get email => _email;

  set email(value) {
    _email = value;
  }

  get name => _name;

  set name(value) {
    _name = value;
  }

  get uid => _uid;

  set uid(value) {
    _uid = value;
  }

  Map<String, dynamic> toJson() => {
    'uid': _uid,
    'name': _name,
    'email': _email,
    'genre': _genre,
    'bornDate': _bornDate,
    'urlPicture': _urlPicture,
  };

  User.fromJson(Map<String, dynamic> json)
      : _uid = json['uid'],
        _name = json['name'],
        _email = json['email'],
        _genre = json['genre'],
        _bornDate = json['bornDate'],
        _urlPicture = json['urlPicture'];
}