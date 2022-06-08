s = input("请输入需要转换的字符串：")
with open("ram.txt",'w', encoding='utf-8') as f:
    for i in range(len(s)):
        item = s[i]
        if(item==' '):
            a=0
        elif((item>='a') & (item<='z')):
            a=ord(item)-ord('a')+11
        elif((item>='A') & (item<='Z')):
            a=ord(item)-ord('A')+37
        else:
            a=0
        print(a)
        f.write('{:x}\n'.format(a))

    