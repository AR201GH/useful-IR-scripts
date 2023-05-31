#import libraries to use to decode base64
import base64
import sys

#function to decode base64 in utf-8 from user input
def decode_base64():
    user_input = input("Enter base64 to decode: ")
    decode = base64.b64decode(user_input).decode('utf-8')
    print(decode)

#print decoded base64
decode_base64()
