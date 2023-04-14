from awscli.compat import six
from awscli.formatter import TableFormatter
from awscli.table import MultiTable, ColorizedStyler
import sys
import json


class Object(object):
    def __init__(self, **kwargs):
        self.__dict__.update(kwargs)
        self.query = None

stream = six.StringIO()
styler = ColorizedStyler()
table = MultiTable(initial_section=False,
                   column_separator='|', styler=styler)
formatter = TableFormatter(Object(color='on'))
formatter.table = table


DATA = [json.loads(line) for line in sys.stdin.readlines() if line.strip()]
formatter(sys.argv[1], DATA, stream=stream)
if output := stream.getvalue():
    print(output)