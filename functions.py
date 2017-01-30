import gdb


class OutputMatches(gdb.Function):
    '''Report whether the output of a given command includes some regex.

    This function is most useful to force existing gdb commands into a
    pipeline. So that one can do 
        pipe ... |  if $_output_contains("info symbol {}", ".text") | ...
    to filter based on whether an address given is in the text segment.

    Note, double quotes are required so that gdb passes the strings across to
    this python function as strings. Single quotes would be treated by gdb as
    quoting a file or function name (see info gdb section 'Program Variables'
    and section 'Examining the Symbol Table').

    Usage:
        $_output_contains(command_string, search_regex) => boolean

    '''
    def __init__(self):
        super(OutputMatches, self).__init__('_output_contains')

    def invoke(self, command, search_pattern):
        gdb_output = gdb.execute(command.string(), False, True)
        if re.search(search_pattern.string(), gdb_output):
            return True
        return False


OutputMatches()
