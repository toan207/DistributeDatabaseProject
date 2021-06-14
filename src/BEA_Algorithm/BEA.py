from math import inf

s = [[3,3,7],
    [0,9,3],
    [8,1,9]]
aff = [sum(i) for i in s]

mx = [
    [1,0,1,1,1],
    [1,0,0,1,1],
    [1,0,0,1,1]]

fo = open("test.txt", "r")

n = int(fo.readline())
mx = []
s  = []
for i in range(n):
    mx.append(list(map(int, fo.readline().split())))
m = int(fo.readline())
for i in range(m):
    s.append(list(map(int, fo.readline().split())))
aff = [sum(i) for i in s]

def printMx():
    print('\t\tMa tran khoi tao')
    for i in range(len(mx[0])):
        print('\tC' + str(i + 1), end='')
    for i in range(len(s[0])):
        print('\tS' + str(i + 1), end='')
    print('\tAff')
    a = 0
    for i in range(len(s)):
        print('AP' + str(a + 1), end='\t')
        a += 1
        for x in mx[i]:
            print(x,end='\t')
        for x in s[i]:
            print(x,end='\t')
        print(aff[i])
    print()

def calcAffMX():
    mx_t = [[0]  * (len(mx[0])) for j in range(len(mx[0]))]
    for i in range(len(mx)):
        for j in range(len(mx[i])):
            for x in range(len(mx[i])):
                if mx[i][x] and mx[i][j] and j != x:
                    mx_t[x][j] += aff[i]
    for i in range(len(mx_t)):
        mx_t[i][i] = sum(mx_t[i])
    return mx_t

def calcBondShow(posX,posY,X,Y):
    bond = 0
    product = []
    for i in range(len(X)):
        bond += X[i] * Y[i]
        product.append(X[i] * Y[i])
    print("\tC" + str(posX) + "      = ",X,sep='')
    print("\tC" + str(posY) + "      = ",Y,sep='')
    print("\tproduct = ",product,sep='')
    print("\tBond = ",end="")
    for i in range(len(X)):
        print(product[i],end='')
        if i != len(X) - 1:
            print(" + ",end='')
    print(" = " + str(bond))
    print()
    return bond

def calcBond(X,Y):
    bond = 0
    for i in range(len(X)):
        bond += X[i] * Y[i]
    return bond

def calcCont(X,Y,Z):
    return 2*calcBond(X,Y) + 2*calcBond(Y,Z) - 2*calcBond(X,Z)

mx_t = calcAffMX()
default = [i for i in range(len(mx_t))]
def printMatrix(mx, order = default):
    for i in order:
        print('\tC' + str(i + 1), end='')
    print()
    a = 0
    for i in order:
        print('C' + str(i+1), end='\t')
        a += 1
        for j in order:
            print(mx_t[i][j], end='\t')
        print()

def solve():
    printMx()
    print('\t\tMa tran hap dan')
    printMatrix(mx_t)
    print()

    print('\tTinh Cont va Bond sap xep lai ma tran')
    order = [0,1]
    n = len(mx_t)
    for x in range(2,n):
        print("\t\tXep C" + str(x+1))
        pos = -1
        v0 = [0] * n
        cont = calcCont(v0,mx_t[x],mx_t[order[0]])
        calcBondShow(0,x+1,v0,mx_t[x])
        calcBondShow(x+1,order[0] + 1,mx_t[x],mx_t[order[0]])
        calcBondShow(0,order[0] + 1,v0,mx_t[order[0]])
        print("Cont(" + "C0" + ", C" + str(x+1) + ", C" + str(order[0]+1) +") = 2*" + str(calcBond(v0,mx_t[x])) + " + 2*" + str(calcBond(mx_t[x],mx_t[order[0]])) + " - 2*" + str(calcBond(v0,mx_t[order[0]])) + " = " + str(cont))
        print()
        for i in range(len(order)-1):
            temp = calcCont(mx_t[order[i]],mx_t[x],mx_t[order[i+1]])
            if cont < temp:
                cont = temp
                pos = i
            calcBondShow(order[i] + 1,x+1,mx_t[order[i]],mx_t[x])
            calcBondShow(x+1,order[i+1] + 1,mx_t[x],mx_t[order[i+1]])
            calcBondShow(order[i] + 1,order[i+1] + 1,mx_t[order[i]],mx_t[order[i+1]])
            print("Cont(" + "C" + str(order[i]+1) + ", C" + str(x+1) + ", C" + str(order[i+1]+1) +") = 2*" + str(calcBond(mx_t[order[i]],mx_t[x])) + " + 2*" + str(calcBond(mx_t[x],mx_t[order[i+1]])) + " - 2*" + str(calcBond(mx_t[order[i]],mx_t[order[i+1]])) + " = " + str(temp))
            print()

        last = calcCont(mx_t[order[-1]],mx_t[x],v0)
        calcBondShow(order[-1]+1,x+1,mx_t[order[-1]],mx_t[x])
        calcBondShow(x+1,0,mx_t[x],v0)
        calcBondShow(order[-1]+1,0,mx_t[order[-1]],v0)
        print("Cont(" + "C" + str(order[-1]+1) + ", C" + str(x+1) + ", C0" +") = 2*" + str(calcBond(mx_t[order[-1]],mx_t[x])) + " + 2*" + str(calcBond(mx_t[x],v0)) + " - 2*" + str(calcBond(v0,mx_t[order[-1]])) + " = " + str(last))
        
        if cont < last:
            cont = last
            pos = x-1
        if pos == -1:
            print("Chon Cont(C0, C" + str(x+1) + ", C" + str(order[0]+1) + ") = " + str(cont))
        elif pos == x-1:
            print("Chon Cont(C" + str(order[-1]+1) + ", C" + str(x+1) + ", C" + str(0) +") = " + str(cont))
        else:
            print("Chon Cont(C" + str(pos + 1) + ", C" + str(x+1) + ", C" + str(pos + 2) +") = " + str(cont))
        order = order[:pos+1] + [x] + order[pos+1:]
        print("Ma tran sau khi sap xep la:")
        printMatrix(mx_t,order)
        print()

    mxZ = []
    pos = 0
    Z = -inf
    print("\t\tTinh Z lan luot tu tren xuong")
    for o in range(n-1):
        TC  = []
        BC  = []
        BOC = []
        TCW  = 0
        BCW  = 0
        BOCW = 0
        for x in range(len(mx)):
            fT = 1
            fB = 1
            for y in range(n):
                if mx[x][y] and y not in order[:o+1]:
                    fT = 0
                if mx[x][y] and y not in order[o+1:]:
                    fB = 0
            TCW  += aff[x]*fT
            BCW  += aff[x]*fB
            BOCW += aff[x]*(not fT and not fB)
            if fT:
                TC.append([x,aff[x]])
            if fB:
                BC.append([x,aff[x]])
            if not fB and not fT:
                BOC.append([x,aff[x]])
        tZ = TCW * BCW - BOCW * BOCW
        mxZ.append(tZ)

        print("TCW  = ", end='')
        for i in range(len(TC)):
            print('AFF(' + str(TC[i][0] + 1) + ') ',end='')
            if i != len(TC) - 1:
                print(' + ', end='')
            else:
                print(' = ', end='')
        if len(TC) > 1:
            for i in range(len(TC)):
                print(TC[i][1],end='')
                if i != len(TC) - 1:
                    print(' + ', end='')
                else:
                    print(' = ', end='')
        print(TCW)

        print("BCW  = ", end='')
        for i in range(len(BC)):
            print('AFF(' + str(BC[i][0] + 1) + ') ',end='')
            if i != len(BC) - 1:
                print(' + ', end='')
            else:
                print(' = ', end='')
        if len(BC) > 1:
            for i in range(len(BC)):
                print(BC[i][1],end='')
                if i != len(BC) - 1:
                    print(' + ', end='')
                else:
                    print(' = ', end='')
        print(BCW)

        print("BOCW = ", end='')
        for i in range(len(BOC)):
            print('AFF(' + str(BOC[i][0] + 1) + ') ',end='')
            if i != len(BOC) - 1:
                print(' + ', end='')
            else:
                print(' = ', end='')
        if len(BOC) > 1:
            for i in range(len(BOC)):
                print(BOC[i][1],end='')
                if i != len(BOC) - 1:
                    print(' + ', end='')
                else:
                    print(' = ', end='')
        print(BOCW)
        print('Z' + str(order[o+1] + 1) + ' = TCW*BCW - BOCW^2 = ' + str(TCW) + '*' + str(BCW) + ' - ' + str(BOCW) + '^2 = ' + str(tZ))
        print()
        if tZ > Z:
            Z = tZ
            pos = o

    print('=> Ta co Zmax = Z' + str(order[pos+1] + 1) + ' =',Z,'tai hang va cot C' + str(order[pos + 1] + 1))
    newOrder = order[1:] + order[:1]
    inB = len(newOrder)
    f = 0

    print('\n\t\tMa tran sau khi chuyen InnerBlock')
    printMatrix(mx_t,newOrder)

    TC  = []
    BC  = []
    BOC = []
    TCW  = 0
    BCW  = 0
    BOCW = 0
    for x in range(len(mx)):
        fT = 1
        fB = 1
        for y in range(n):
            if mx[x][y] and y not in newOrder[:inB-2]:
                fT = 0
            if mx[x][y] and y not in newOrder[inB-2:]:
                fB = 0
        TCW  += aff[x]*fT
        BCW  += aff[x]*fB
        BOCW += aff[x]*(not fT and not fB)
        if fT:
            TC.append([x,aff[x]])
        if fB:
            BC.append([x,aff[x]])
        if not fB and not fT:
            BOC.append([x,aff[x]])
    ibZ = TCW * BCW - BOCW * BOCW
    mxZ.append(ibZ)

    print("TCW  = ", end='')
    for i in range(len(TC)):
        print('AFF(' + str(TC[i][0] + 1) + ') ',end='')
        if i != len(TC) - 1:
            print(' + ', end='')
        else:
            print(' = ', end='')
    if len(TC) > 1:
        for i in range(len(TC)):
            print(TC[i][1],end='')
            if i != len(TC) - 1:
                print(' + ', end='')
            else:
                print(' = ', end='')
    print(TCW)

    print("BCW  = ", end='')
    for i in range(len(BC)):
        print('AFF(' + str(BC[i][0] + 1) + ') ',end='')
        if i != len(BC) - 1:
            print(' + ', end='')
        else:
            print(' = ', end='')
    if len(BC) > 1:
        for i in range(len(BC)):
            print(BC[i][1],end='')
            if i != len(BC) - 1:
                print(' + ', end='')
            else:
                print(' = ', end='')
    print(BCW)

    print("BOCW = ", end='')
    for i in range(len(BOC)):
        print('AFF(' + str(BOC[i][0] + 1) + ') ',end='')
        if i != len(BOC) - 1:
            print(' + ', end='')
        else:
            print(' = ', end='')
    if len(BOC) > 1:
        for i in range(len(BOC)):
            print(BOC[i][1],end='')
            if i != len(BOC) - 1:
                print(' + ', end='')
            else:
                print(' = ', end='')
    print(BOCW)
    print('Z = TCW*BCW - BOCW^2 = ' + str(TCW) + '*' + str(BCW) + ' - ' + str(BOCW) + '^2 = ' + str(ibZ))
    print()

    print('Cac Z da duoc tinh = ',mxZ)

    if not f and ibZ > Z:
        print('=> Ta chon Z =',max(mxZ),'la innerBlock')
        print('=> ', end='')
        newOrder = list(map(lambda x: "C" + str(x + 1), newOrder))
        print("Sau khi thêm khóa C cho vùng trên ta được kết quả hai mảnh dọc sau: ", "VF1",["C"] + newOrder[:inB-2],", VF2",["C"] + newOrder[inB-2:],sep='')
    else:
        print('=> Ta chon Z = ' + str(max(mxZ)) +' la Z' + str(order[pos+1] + 1))
        print('=> ', end='')
        order    = list(map(lambda x: "C" + str(x + 1), order))
        print("Sau khi thêm khóa C cho vùng trên ta được kết quả hai mảnh dọc sau: ", "VF1",["C"] + order[pos+1:],", VF2",["C"] + order[:pos+1],sep='')
    
solve()