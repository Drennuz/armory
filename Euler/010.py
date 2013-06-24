'''
Project Euler Problem 001 -- 010
'''

'''
001: sum of all the multiples of 3 or 5 below 1000
'''

def P001(upper_bound):
    total = 0
    for i in range(1, upper_bound):
        if i%3 == 0 or i%5 == 0:
            total += i
    return total

'''
001: sum of even-valued terms in Fibonacci sequence <= 4m
'''

def P002(upper_bound):
    first = 1
    second = 1
    total = 0
    while True:
        fib = first + second
        if fib > upper_bound:
            break
        if fib%2 == 0:
            total += fib
        first = second
        second = fib
    return total 

if __name__ == '__main__':
    print(P002(4000000))

