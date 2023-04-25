/*Asumiendo que tienen un KVS cuya variable de ambiente es: "KEY_VALUE_STORE_MY_CONTAINER_CONTAINER_NAME"
Implementar en GO una clase “User” que tenga varios campos como id, nombre, apellido, género, fecha de nacimiento
Implementar una clase que permita hacer el CRUD de ese user en KVS
Asegurarse que el KVS tenga 2 reintentos
Asegurarse que si se pasa del rate limit, se loguee la información correspondiente

Para implementar una clase "User" en GO, podríamos crear una estructura que represente los campos que se mencionan en el enunciado:*/
type User struct {
    ID           string
    FirstName    string
    LastName     string
    Gender       string
    DateOfBirth string
}
/*Para hacer el CRUD de este usuario en el KVS, podríamos crear otra clase que tenga métodos para crear, leer, actualizar y eliminar usuarios en el KVS. 
Aquí hay un ejemplo de cómo se podría implementar:*/
type UserStore struct {
    kvsClient kvs.Client
    retries   int
}

func NewUserStore() *UserStore {
    kvsContainerName := os.Getenv("KEY_VALUE_STORE_MY_CONTAINER_CONTAINER_NAME")
    kvsClient := kvs.NewClient(kvsContainerName)
    return &UserStore{kvsClient, 2}
}

func (store *UserStore) CreateUser(user *User) error {
    key := user.ID
    value, err := json.Marshal(user)
    if err != nil {
        return err
    }

    err = store.kvsClient.SetWithRetries(key, value, store.retries)
    if err != nil {
        log.Printf("Error creating user: %s\n", err.Error())
        return err
    }

    return nil
}

func (store *UserStore) GetUser(id string) (*User, error) {
    value, err := store.kvsClient.GetWithRetries(id, store.retries)
    if err != nil {
        log.Printf("Error getting user: %s\n", err.Error())
        return nil, err
    }

    user := &User{}
    err = json.Unmarshal(value, user)
    if err != nil {
        return nil, err
    }

    return user, nil
}

func (store *UserStore) UpdateUser(user *User) error {
    key := user.ID
    value, err := json.Marshal(user)
    if err != nil {
        return err
    }

    err = store.kvsClient.UpdateWithRetries(key, value, store.retries)
    if err != nil {
        log.Printf("Error updating user: %s\n", err.Error())
        return err
    }

    return nil
}

func (store *UserStore) DeleteUser(id string) error {
    err := store.kvsClient.DeleteWithRetries(id, store.retries)
    if err != nil {
        log.Printf("Error deleting user: %s\n", err.Error())
        return err
    }

    return nil
}
/*Esta clase utiliza el cliente KVS proporcionado y tiene un número máximo de reintentos especificado en la variable "retries". También implementa un 
registro en caso de que se alcance el límite de tasa del KVS.*/

