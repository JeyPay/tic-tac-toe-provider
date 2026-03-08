typedef Constructor<M> = M Function();

abstract class Injector {
  static final Map<Type, Object> _objects = {};
  static final Map<Type, Constructor> _constructors = {};

  static void register<M extends Object>(M obj) {
    _objects[M] = obj;
  }

  static M? maybeGet<M extends Object>() => _objects[M] as M?;

  static M get<M extends Object>() => _objects[M]! as M;

  static void registerConstructor<C extends Object>(Constructor fct) => _constructors[C] = fct;

  static Constructor<C>? maybeGetConstructor<C extends Object>() => _constructors[C] as Constructor<C>?;

  static Constructor<C> getConstructor<C extends Object>() => _constructors[C]! as Constructor<C>;
}
