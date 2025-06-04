class negocios {

  var _nid;
  var _name;
  var _description;
  var _activo;
  var _tipo;
  var _uid;
  var _logo;
  var _latitud;
  var _longitud;
  var _fechaCreacion;

  var _Lproductos;
  var _Lreservas;
  var _productos;
  var _reservas;

  negocios(this._nid, this._name, this._description, this._activo, this._tipo, this._uid, this._logo,
            this._latitud, this._longitud, this._fechaCreacion, this._Lproductos, this._Lreservas,
            this._productos, this._reservas);

  get reservas => _reservas;

  set reservas(value) {
    _reservas = value;
  }

  get prodcutos => _productos;

  set productos(value) {
    _productos = value;
  }

  get Lreservas => _Lreservas;

  set Lreservas(value) {
    _Lreservas = value;
  }

  get Lproductos => _Lproductos;

  set Lproductos(value) {
    _Lproductos = value;
  }

  get fechaCreacion => _fechaCreacion;

  set fechaCreacion(value) {
    _fechaCreacion = value;
  }

  get longitud => _longitud;

  set longitud(value) {
    _longitud = value;
  }

  get latitud => _latitud;

  set latitud(value) {
    _latitud = value;
  }

  get logo => _logo;

  set logo(value) {
    _logo = value;
  }

  get uid => _uid;

  set uid(value) {
    _uid = value;
  }

  get tipo => _tipo;

  set tipo(value) {
    _tipo = value;
  }

  get activo => _activo;

  set activo(value) {
    _activo = value;
  }

  get description => _description;

  set description(value) {
    _description = value;
  }

  get name => _name;

  set name(value) {
    _name = value;
  }

  get nid => _nid;

  set nid(value) {
    _nid = value;
  }

  Map<String, dynamic> toJson() => {
    "NID": _nid,
    "nombre": _name,
    "description": _description,
    "activo": _activo,
    "tipo": _tipo,
    "UID": _uid,
    "logo": _logo,
    "latitud": _latitud,
    "longitud": _longitud,
    "fechaCreacion": _fechaCreacion,
    "Lproductos": _Lproductos,
    "Lreservas": _Lreservas,
    "productos": _productos,
    "reservas": _reservas,
  };

  negocios.fromJson(Map<String, dynamic> json)
      : _nid = json['NID'],
        _name = json['nombre'],
        _description = json['description'],
        _activo = json['activo'],
        _tipo = json['tipo'],
        _uid = json['UID'],
        _logo = json['logo'],
        _latitud = json['latitud'],
        _longitud = json['longitud'],
        _fechaCreacion = json['fechaCreacion'],
        _Lproductos = json['Lproductos'],
        _Lreservas = json['Lreservas'],
        _productos = json['productos'],
        _reservas = json['reservas'];
}