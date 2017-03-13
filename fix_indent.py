import re
import math
from fractions import gcd

test_snip = '''
class SomeClass(object):
    """Docstring for SomeClass """

    def __init__(self):
        """@todo: to be defined """
        return

    def someFunc(self):
        return
'''

# Simple wrapper around gcd to find the gcd of an array of numbers
def gcdd(nums):
    res = nums[0]

    for num in nums[1:]:
        res = gcd(num, res)

    return res

# TODO: If we're not able to find and indent that's better than 1 the first
# time around then we need to probably strip the outliers (this could happen
# when) there's extra whitespace for alignment like with function parameters.
def fix_indent(snip):
    space_nums = []
    lines = re.split('[\n\r]+', snip)

    for i,line in enumerate(lines):
        num_spaces = len(re.match('^\s*', line).group(0))
        space_nums.append(num_spaces)

    indent = gcdd(space_nums)
    rpat = '^{0}'.format(''.join(' ' for i in range(5)))

    for i,line in enumerate(lines):
        lines[i] = \
            ''.join('\t' for n in range(space_nums[i]/indent)) + \
            lines[i][space_nums[i] - space_nums[i] % indent:]

    print '\n'.join(lines)

fix_indent(test_snip)
