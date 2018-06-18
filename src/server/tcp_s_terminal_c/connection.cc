
#include <connection.h>

#include <unistd.h>

Tcp::Connection::Connection(Genode::Env &env, int socket, char const *label) :
    Genode::Thread(env, label, CONNECTION_BUFFER + 4096),
    _terminal(env, label),
    _read_sigh(env.ep(), *this, &Tcp::Connection::handle_response),
    _socket(socket),
    _closed(false)
{
    _terminal.read_avail_sigh(_read_sigh);
}

void Tcp::Connection::entry()
{
    char buffer[CONNECTION_BUFFER];
    long received, sent;

    while(!_closed){
        Genode::memset(buffer, 0, sizeof(buffer));
        sent = 0;
        received = 0;
        LIBC(read, buffer, sizeof(buffer), &received);
        if(received > 0 && !_closed){
            while(sent < received){
                sent += _terminal.write(&buffer[sent], received - sent);
                LIBC(close);
            }
        }
    }
}

void Tcp::Connection::handle_response()
{
    char buffer[CONNECTION_BUFFER];
    long received, sent;

    if(!_terminal.avail()){
        LIBC(close);
        return;
    }

    while(!_closed && _terminal.avail()){
        Genode::memset(buffer, 0, sizeof(buffer));
        sent = 0;
        received = _terminal.read(buffer, sizeof(buffer));
        while(sent < received){
            LIBC(write, &buffer[sent], received - sent, &sent);
        }
    }
}

bool Tcp::Connection::closed() const
{
    return _closed;
}

void Tcp::Connection::lc_read(void *buffer, Genode::size_t size, long *result)
{
    *result += read(_socket, buffer, size);
    if(*result < 1){
        LIBC(close);
    }
}

void Tcp::Connection::lc_write(void const *buffer, Genode::size_t size, long *result)
{
    *result += write(_socket, buffer, size);
    if(*result < 1){
        LIBC(close);
    }
}

void Tcp::Connection::lc_close()
{
    _closed = true;
    close(_socket);
}
