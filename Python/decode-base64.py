#import libraries to use to decode base64
import base64
import sys

#function to decode base64 in utf-8
def decode_base64():
    #get input from user
    user_input = input("Enter base64 to decode: ")
    #decode base64
    decode = base64.b64decode(user_input).decode('utf-8')
    #print decoded base64
    print(decode)

#print decoded base64
decode_base64()
