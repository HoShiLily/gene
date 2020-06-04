def get_value(s):
    s = s.rstrip(',')
    s = s.rstrip('\"')
    index = s.find('=')
    return s[index+1:]



# main

input = 'pairs.raw.txt'

f = open(input)
lines = f.readlines()
f.close()

f = open('result.raw.txt', 'w') 
f.write('%s\n' % '\t'.join(['r', 'n', 'raw.likelihood']))
for line in lines:
    line = line.strip()
    lst = line.split(' ')
    result = []
    for x in lst:
        if 'r=' in x or 'n=' in x or 'raw.likelihood=' in x:
            v = get_value(x)
            result.append(v)
    if result != []:
        f.write('%s\n' % '\t'.join(result))

f.close()
