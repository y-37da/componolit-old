#include <signal.h>

int sigwait(const sigset_t *set, int *sig)
{
    *sig = SIGQUIT;
    return 0;
}

