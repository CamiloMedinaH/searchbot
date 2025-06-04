class User{
  var _uid;
  var _name;
  var _email;
  var _genre;
  var _bornDate;
  var _urlPicture;

  var _lnegocios;
  var _lreservas;
  var _historial;

  User(this._uid, this._name, this._email, this._genre, this._bornDate,
      this._urlPicture, this._lreservas, this._lnegocios, this._historial);

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

  get lnegocios => _lnegocios;

  set lnegocios(value) {
    _lnegocios = value;
  }

  get lreservas => _lreservas;

  set lreservas(value) {
    _lreservas = value;
  }

  get historial => _historial;

  set historial(value) {
    _historial = value;
  }

  Map<String, dynamic> toJson() => {
    'UID': _uid,
    'nombre': _name,
    'correo': _email,
    'genero': _genre,
    'creationDate': _bornDate,
    'imagen': _urlPicture,
    'LNegocios': _lnegocios,
    'LReservas': _lreservas,
    'historial': _historial,
  };

  User.fromJson(Map<String, dynamic> json)
      : _uid = json['UID'],
        _name = json['nombre'],
        _email = json['correo'],
        _genre = json['genero'],
        _bornDate = json['creationDate'],
        _urlPicture = json['imagen'],
        _lnegocios = json['LNegocios'],
        _lreservas = json['LReservas'],
        _historial = json['historial'];
}