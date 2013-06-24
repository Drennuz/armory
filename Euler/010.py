'''
Project Euler Problem 001 -- 010
'''
import functools, math
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
002: sum of even-valued terms in Fibonacci sequence <= 4m
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

'''
003: largest prime factor of 600851475143
'''
def P003(upper_bound):
    prime_upper_bound = int(upper_bound**0.5)
    prime = find_prime(prime_upper_bound)     
    for i in range(len(prime)-1, -1, -1):
        if upper_bound % prime[i] == 0:
            break
    return prime[i]

def find_prime(n):
    all_numbers = [True for i in range(0, n+1)]
    l = len(all_numbers)
    all_numbers[0] = False
    all_numbers[1] = False

    for i in range(2, l):
        if all_numbers[i]:
            for j in range(i, math.ceil(l/i)):
                all_numbers[i*j] = False
    prime = [i for i in range(0, l) if all_numbers[i]]
    return prime

'''
004: largest palindrom from product of two 3-digit numbers
'''
def P004():
    def palindrome(n):
        n = str(n)
        l = len(n)
        end = int(l/2)
        for i in range(0, end):
            if n[i] != n[l-1-i]:
                return False
        return True
    upper = 1000
    a = [i * j for i in range(1, upper) for j in range(1, upper)]
    a.sort(reverse = True)
    for i in range(len(a)):
        if palindrome(a[i]):
            break
    return a[i]

'''
005: smallest positive number evenly divisible by all numbers from 1 to 20
'''
def P005(n):
    prime = find_prime(n)
    print(prime)
    rem = [i for i in range(4, n+1) if n not in prime]
    def evenly_divide(i, lis):
        for j in lis:
            if i % j != 0:
                return False
        return True
    initial = functools.reduce(lambda x, y: x*y, prime)
    k = 1
    while True:
        if evenly_divide(initial * k, rem):
            break
        k += 1
    return initial * k

if __name__ == '__main__':
    print(P005(20))
