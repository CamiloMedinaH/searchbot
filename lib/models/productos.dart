class productos {

  var _name;
  var _description;
  var _precio;
  var _unidades;
  var _pic;
  var _nid;
  var _pid;

  productos(this._description, this._name, this._pic, this._precio, this._unidades,
      this._nid, this._pid);

  get pic => _pic;

  set pic(value) {
    _pic = value;
  }

  get unidades => _unidades;

  set unidades(value) {
    _unidades = value;
  }

  get precio => _precio;

  set precio(value) {
    _precio = value;
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

  get pid => _pid;

  set pid(value) {
    _pid = value;
  }

  Map<String, dynamic> toJson() => {
    "NID": _nid,
    "nombre": _name,
    "description": _description,
    "PID": _pid,
    "Precio": _precio,
    "imagen": _pic,
    "Unidades": _unidades
  };

  productos.fromJson(Map<String, dynamic> json)
      : _nid = json['NID'],
        _name = json['nombre'],
        _description= json['description'],
        _pid= json['PID'],
        _precio= json['Precio'],
        _pic= json['imagen'],
        _unidades= json['Unidades'];

}