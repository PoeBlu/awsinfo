import os
import sys

DIR = sys.argv[1]
COMMANDS_PATH = f"{DIR}/commands"

options = ['help', 'verbose', 'source', 'region', 'profile']
param_options = [f'--{o}' for o in options]
joined_options = ' '.join(param_options)
commands = os.listdir(COMMANDS_PATH)
print('_awsinfo_complete () {')
print(f"""COMMANDS="{' '.join(commands)}\"""")
print('''
COMPREPLY=($(compgen -W "$COMMANDS" -- "$2"))
if [[ "$3" == "awsinfo" ]]
then
  COMPREPLY=($(compgen -W "$COMMANDS" -- "$2"))''')
print('''
elif [[ "$2" =~ ^- ]]
then
  COMPREPLY=($(compgen -W "{}" -- "$2"))'''.format(joined_options))
print('''
else
case "$3" in''')

for command in commands:
    subfiles = os.listdir(f'{COMMANDS_PATH}/{command}')
    subcommands = (' '.join([s.split('.')[0] for s in subfiles if s.endswith('.bash') and s != 'index.bash']))
    # if subcommands:
    print(f'    {command}) COMPREPLY=($(compgen -W "{subcommands}" "$2"));;')

print('    *) COMPREPLY=();;')

print('''
esac
fi

}
''')

print('complete -F _awsinfo_complete awsinfo')
