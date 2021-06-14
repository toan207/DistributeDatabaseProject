#include <bits/stdc++.h>
using namespace std;

#define vi vector<int>
#define vvi vector<vector<int>>

int bond(vi X, vi Y)
{
    int sm = 0;
    for (int i = 0; i<X.size(); ++i)
        sm += X[i] * Y[i];
    return sm;
}

int cont(vi X, vi Y, vi Z)
{
    return 2*bond(X,Y) + 2*bond(Y,Z) - 2*bond(X,Z);
}

int main()
{
    int n = 3, m = 5, mA = 3;
    vvi mx = {
        {1,0,1,1,1},
        {1,0,0,1,1},
        {1,0,0,1,1}
    };
    vvi mxA = {
        {3,3,7},
        {0,9,3},
        {8,1,9}
    };
    vi aff;
    for (int i = 0; i<n; ++i)
    {
        int temp = 0;
        for (int j = 0; j<mA; ++j)
            temp += mxA[i][j];
        aff.push_back(temp);
    }

    cout<<"\t\tMa tran khoi tao"<<endl;
    cout<<"\t";
    for (int i = 0; i<m; ++i)
        cout<<"C"<<i+1<<"\t";
    for (int i = 0; i<mA; ++i)
        cout<<"S"<<i+1<<"\t";
    cout<<"Aff"<<endl;
    for (int i = 0; i<n; ++i)
    {
        cout<<"AP"<<i+1<<"\t";
        for (int j = 0; j<m; ++j)
            cout<<mx[i][j]<<"\t";
        for (int j = 0; j<mA; ++j)
            cout<<mxA[i][j]<<"\t";
        cout<<aff[i]<<endl;
    }

    vvi mxAff;
    for (int i = 0; i<m; ++i)
    {
        vi t(m);
        mxAff.push_back(t);
    }
    

    for (int i = 0; i<n; ++i)
    {
        for (int x = 0; x<m; ++x)
        {
            for (int y = 0; y<m; ++y)
            {
                if (x == y)
                    continue;
                if (mx[i][x] && mx[i][y])
                    mxAff[y][x] += aff[i];
            }
        }
    }
    for (int i = 0; i<m; ++i)
    {
        int sm = 0;
        for (int j = 0; j<m; ++j)
            sm += mxAff[i][j];
        mxAff[i][i] = sm;
    }
    cout<<"\t\tMa tran hap dan"<<endl;
    cout<<"\t";
    for (int i = 0; i<m; ++i)
        cout<<"C"<<i+1<<"\t";
    cout<<endl;
    for (int i = 0; i<m; ++i)
    {
        cout<<"C"<<i+1<<"\t";
        for (int j = 0; j<m; ++j)
            cout<<mxAff[i][j]<<"\t";
        cout<<endl;
    }

    vi order = {0,1};
    for (int i = 2; i<m; ++i)
    {
        vi v0(m);
        int pos = -1;
        int cnt = cont(v0,mxAff[i],mxAff[order[0]]);
        for (int j = 0; j<m-1; ++j)
        {
            int temp = cont(mxAff[j],mxAff[i],mxAff[j+1]);
            if (temp > cnt)
            {
                cnt = temp;
                pos = 0;
            }
        }
        int temp = cont(mxAff[order[order.size()-1]], mxAff[i], v0);
        if (temp > cnt)
        {
            cnt = temp;
            pos = i - 1;
        }
        order.push_back(i);
        for (int j = order.size() - 1; j > pos + 1; --j)
            swap(order[j], order[j-1]);
    }
    cout<<endl;
    cout<<"\t\tMa tran sau sap xep"<<endl;
    cout<<"\t";
    for (int i: order)
        cout<<"C"<<i+1<<"\t";
    cout<<endl;
    for (int i: order)
    {
        cout<<"C"<<i+1<<"\t";
        for (int j: order)
            cout<<mxAff[i][j]<<"\t";
        cout<<endl;
    }

    int pos = 0;
    long long Z = -1e9;
    vi check(m);
    for (int i = 0; i<m-1; ++i)
    {
        int TCW  = 0;
        int BCW  = 0;
        int BOCW = 0;
        check[order[i]] = 1;
        for (int x = 0; x<n; ++x)
        {
            bool fT = true, fB = true;
            for (int y = 0; y<m; ++y)
            {
                if (mx[x][y] && !check[y])
                    fT = false;
                if (mx[x][y] && check[y])
                    fB = false;
            }
            TCW  += aff[x]*fT;
            BCW  += aff[x]*fB;
            BOCW += aff[x]*(!fT && !fB);
        }
        long long tZ = TCW * BCW - BOCW * BOCW;
        if (tZ > Z)
        {
            Z = tZ;
            pos = i;
        }
    }
    vi newOrder;
    for (int i = 1; i<m; ++i)
        newOrder.push_back(order[i]);
    newOrder.push_back(order[0]);
    int TCW  = 0;
    int BCW  = 0;
    int BOCW = 0;
    vi checkt(m);
    for (int i = 0; i<m-2; ++i)
        checkt[newOrder[i]] = 1;
    bool fT = false, fB = false;
    for (int x = 0; x<n; ++x)
    {
        bool fT = true, fB = true;
        for (int y = 0; y<m; ++y)
        {
            if (mx[x][y] && !checkt[y])
                fT = false;
            if (mx[x][y] && checkt[y])
                fB = false;
        }
        TCW  += aff[x]*fT;
        BCW  += aff[x]*fB;
        BOCW += aff[x]*(!fT && !fB);
    }
    long long tZ = TCW * BCW - BOCW * BOCW;
    if (tZ > Z)
    {
        cout<<"Co 2 manh la: VF1(";
        for (int i = 0; i<m-2; ++i)
        {
            cout<<newOrder[i] + 1;
            if (i != m-3)
                cout<<", ";
            else
                cout<<"), ";
        }
        cout<<"VF2(";
        for (int i = m-2; i<m; ++i)
        {
            cout<<newOrder[i] + 1;
            if (i != m-1)
                cout<<", ";
            else
                cout<<").";
        }
    }
    else
    {
        cout<<"Co 2 manh la: VF1(";
        for (int i = 0; i<pos + 1; ++i)
        {
            cout<<order[i] + 1;
            if (i != pos)
                cout<<", ";
            else
                cout<<"), ";
        }
        cout<<"VF2(";
        for (int i = pos + 1; i<m; ++i)
        {
            cout<<order[i] + 1;
            if (i != m-1)
                cout<<", ";
            else
                cout<<").";
        }
    }
    return 0;
}