# This file must be used with "source bin/activate" *from bash*
# you cannot run it directly

ll_deactivate () {
    if [ -n "$_OLD_PATH" ] ; then
        PATH="$_OLD_PATH"
        export PATH
        unset _OLD_PATH
    fi
    if [ -n "$_OLD_MODULEBUILDRC" ] ; then
        MODULEBUILDRC="$_OLD_MODULEBUILDRC"
        export MODULEBUILDRC
        unset _OLD_MODULEBUILDRC
    fi
    if [ -n "$_OLD_PERL_MM_OPT" ] ; then
        PERL_MM_OPT="$_OLD_PERL_MM_OPT"
        export PERL_MM_OPT
        unset _OLD_PERL_MM_OPT
    fi
    if [ -n "$_OLD_PERL5LIB" ] ; then
        PERL5LIB="$_OLD_PERL5LIB"
        export PERL5LIB
        unset _OLD_PERL5LIB
    fi

    # This should detect bash and zsh, which have a hash command that must
    # be called to get it to forget past commands.  Without forgetting
    # past commands the $PATH changes we made may not be respected
    if [ -n "$BASH" -o -n "$ZSH_VERSION" ] ; then
        hash -r
    fi

    if [ -n "$_OLD_PS1" ] ; then
        PS1="$_OLD_PS1"
        export PS1
        unset _OLD_PS1
    fi

    unset PERL_PROFILE
    if [ ! "$1" = "nondestructive" ] ; then
    # Self destruct!
        unset -f ll_deactivate
    fi
}

# unset irrelavent variables
ll_deactivate nondestructive

PERL_PROFILE="__PERL_PROFILE__"
export PERL_PROFILE

_OLD_PATH="$PATH"

_OLD_PS1="$PS1"
if [ "`basename \"$PERL_PROFILE\"`" = "__" ] ; then
    # special case for Aspen magic directories
    # see http://www.zetadev.com/software/aspen/
    PS1="[`basename \`dirname \"$PERL_PROFILE\"\``] $PS1"
else
    PS1="(`basename \"$PERL_PROFILE\"`)$PS1"
fi
export PS1

_OLD_MODULEBUILDRC="$MODULEBUILDRC"
export _OLD_MODULEBUILDRC
_OLD_PERL_MM_OPT="$PERL_MM_OPT"
export _OLD_PERL_MM_OPT
_OLD_PERL5LIB="$PERL5LIB"
export _OLD_PERL5LIB


eval $( perl -Mlocal::lib=$PERL_PROFILE)

# This should detect bash and zsh, which have a hash command that must
# be called to get it to forget past commands.  Without forgetting
# past commands the $PATH changes we made may not be respected
if [ -n "$BASH" -o -n "$ZSH_VERSION" ] ; then
    hash -r
fi
