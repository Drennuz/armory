def merge(l1, l2):
    m1 = len(l1)
    m2 = len(l2)
    i = j = 0
    l = [0] * (m1+m2)
    for k in range(m1 + m2):
        if i >= m1 and j < m2:
            l[k] = l2[j]
            j += 1
        elif j >= m2 and i < m1:
            l[k] = l1[i]
            i += 1
        elif i < m1 and j < m2:
            if l1[i] < l2[j]:
                l[k] = l1[i]
                i += 1
            else:
                l[k] = l2[j]
                j += 1
    return l

def merge_sort(l):
    halflength = int(len(l)/2)
    l1 = l[:halflength]
    l2 = l[halflength:]
    if len(l) <= 1:
        return l
    return merge(merge_sort(l1), merge_sort(l2))

def merge_and_count (l, l1, l2):
    m1 = len(l1)
    m2 = len(l2)
    count = 0
    i = j = 0
    for k in range(m1 + m2):
        if i >= m1 and j < m2:
            l[k] = l2[j]
            j += 1
        elif j >= m2 and i < m1:
            l[k] = l1[i]
            i += 1
        elif i < m1 and j < m2:
            if l1[i] < l2[j]:
                l[k] = l1[i]
                i += 1
            else:
                l[k] = l2[j]
                count += m1 - i
                j += 1
    return count

def count_inversion(l):
    length = len(l)
    hlen = int(length/2)
    l1 = l[:hlen]
    l2 = l[hlen:]
    if length <= 1:
        return 0
    return count_inversion(l1) + count_inversion(l2) + merge_and_count(l, l1, l2)
        
