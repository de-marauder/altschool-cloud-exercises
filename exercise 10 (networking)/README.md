# IP Addresses

## Introduction

The Internet is a massive network of machine sharing information between each other. It is the largest network that currently exists. But have you ever thought of how these machines identify each other and know how exactly to route information directly to it's intended receipient? Two words, "IP Addresses". This article will provide insightss about these addresses and how they are calculated. 

## What are IP Addresses?

An IP (Internet Protocol) Address is a group of 32 bits used to identify any machine on the internet. Before a device can access the internet, it must have this address. These IP address are unique so you don't have to worry about your information being misplaced. If it is, it was probably intended by someone to be.

How do devices get these addresses though?

IP addresses are distributed by organisations that control and maintain the internet. The distribution is done in way that allows say a company like an Internet Service Provider (ISP) to own particular blocks of addresses which they can in turn distribute to users that wish to access the internet through them. An example of an ISP would be MTN or verizon.

If you would like to see your present public IP, go to google.com and search "What is my IP". You should see a series of numbers in this format `192.168.20.4`. Of course yours will be different.

### Types of IP addresses

In order to distribute these addresses in an orderly manner, a series of calculations must be performed. These calculations allow IPs to be grouped based on distribution methods into:

-   Class based IPs and
-   Classless IPs [CIDR (Classless Inter-Domain Routing)]


**Class based IPs**:
These types of IPs are no longer typically used. This is because of the sheer size of the internet and the incredible number of devices that are connected to it. Remember the definition of an IP address? ~It a number consisting of 32 bits~. This means that there are a finite number of IPs that can go around. 

These class based IPs however encourage the wastage of these IPs and are no longer adopted.

The different classes include:

| Class | Description |
| --- | --- |
| Class A | These can accomodate over 16 million hosts |
| Class B | These can accomodate over 65 thousand hosts |
| Class C | These can accomodate over 254 hosts |

Those are some very big numbers and you can see why I said they encourage the wastage of IPs. It would be quite the feat to completely exhaust the available hosts any of these classes provide except the owners are an incredibly large organisation. 

If you're wondering how this numbers were calculated or what they mean, relax we are getting there.

**Classless IPs**:
These IPs are distributed in a more frugal manner. This prevents wastage of IPS as organisations can now be given IPs for only the number of hosts they own. So if you needed just 10 or 20 hosts, you would not be gifted 254 as would be the case for Class C IPs. This is the method used for distributing IPs nowadays. It is also referred to as CIDR (Classless Inter-Domain Routing).

## How to calculate an IP address

Before we start calculating IP addresses we need to get some definitions out of the way.

As we found out earlier IP address is of the format `*.*.*.*`. Four number between 0 and 255 separated by three periods. 

Incase you're already wondering, the range 0-255 is not just some arbitrary range. This range signifies 256 possible entries which is also 2^8 which is the maximum number that can be contained in 8 bit or an octet when converted to binary. In other words,
| Decimal | Binary |
| :---: | :---: |
| 256 | 11111111 |

So things seem to have started getting complicated but hang in there, it's really all quite simple. 

A octet is a group of 8 bits. In most machines it would also be equivalent to a byte.
A Bit is a single binary digit
A binary  digit is a number in the base 2 counting system which comprises of 1s and 0s. The language of machines

With that out of the way we can see how the IP address `10.15.250.0` can be transformed to its true binary form of `00001010.00001111.11111010.00000000` by converting each decimal number in the IP to their binary form. You can learn how to this this conversion by making simple searches on google or by using any conversion tool you fancy.

We have successfully decoded the true form of an IP address.

### Networks IPs
We have already established that the internet is a giant wide area network (WAN). This is primary because it consists of millions of other nested WANs which in turn consist of other nested networks and so on. But networks are not machines so how does the internet know how to identify them by IP? 

The answer is quite simple, If you think of a network as a hierarchy tree of sorts, at the top node there will always be an IP which tells the internet that a certain number of IPs exist as it's children. In this case the top node becomes the network IP while it's children become the host IP.

At the top of this network hierarchy seats the entire internet with an IP of `0.0.0.0` while every other IP is a child of the internet's IP in a manner of speaking. All [(2^32) - 2] of them. The subtraction excludes the internet's network IP (0.0.0.0) and it's broadcast IP (255.255.255.255).

Before we continue, the broadcast address is the last available IP in a network. This is why the internet has a broadcast IP of `255.255.255.255`. Remember, the nubmers don't get higher than 255.

Hopefully things are starting to add up now.

Remember when we were talking about distributing IPs and hosts? This is what it means to be given a group of IPs. In reality, The first IP in the block you were given becomes the top node of your network while the rest save for the last serve as possible host IPs.

The grouping of IPs is done and calculated via a routine indicated by a **`netmask`** or **`subnet mask`**`. A netmask is simply indicates the number of bits available to be distributed to a given network. It is used to define a range of consecutive IP addresses that could potentially form a network. 

A netmask is typically defined using the format, `a.b.c.d/e` where `a-d` are integers in the range of [0-255] and `e` is the netmask or subnet mask which ranges from [0-32] (for the 32 bit available in an IP address). However, in practice, the netmask range would typically be within [8-31]

Using the class based system of IP address distribution, only the following netmasks would be used:
- /8 for class A
- /16 for class B and
- /24 for class C

This is the reason for the outrageous nnumber of hosts allocated to the these class based IPs. However, the classless model allows all integers between [0-32] to be assigned as netmasks. This allows IPs to grouped in smaller ammounts by increasing the netmask beyond 24.

Given a particular netmask and IP address say `193.16.20.35/29`. If we were asked to calculate the Network IP, number of hosts, range of IP addresses and broadcast IP from this subnet, the following procedure should be followed.

1. Calculate the wildcard. The wildcard shows the available IP address slots and is obtained by first converting the IP to it's binary form. Then subtracting the netmask from 32. Then counting from the rightmost bit of the binary IP until you reach the difference calculated. At this point, Assign a value of 0 to all bits on the left hand side and a value of 1 to all bits on the right hand side.

```
decimal IP ==> 193.16.20.35
// convert to binary
binary IP ==> 11000001.00010000.00010100.00100011

//Calculate netmask difference
difference = 32 - 29 = 3

// Count 8 from right to left on the binary IP
==> 11000001.00010000.00010100.00100 ^ 011

// the ^ symbol shows the 8th mark
// Now assign the right and left bit values of 1 and 0 respectively

==> wildcard ==> 00000000.00000000.00000000.00000 ^ 111 ==> 0.0.0.7 

// 7 is obtained by converting the binary number 111 on the right hand side to decimal

// this means we have only 7 available slots for this netmask
// This also means that the number of hosts = 7 - 2 = 5

```

2. Identify the network IP. To do this, first of all get the binary IP of the given IP. calculate the netmask differnce and count from the right again. Then change all bits on the right to 1
```
binary IP ==> 11000001.00010000.00010100.00100011

//Calculate netmask difference
difference = 32 - 29 = 3

// Count 8 from right to left on the binary IP
==> 11000001.00010000.00010100.00100 ^ 011
==> Binary Network IP ==> 11000001.00010000.00010100.00100 ^ 000
==> Binary Network IP ==> 11000001.00010000.00010100.00100000

==> Decimal Network IP ==> 193.16.20.32
==> Network IP ==> 193.16.20.32
```

3. Find the broadcast. To do this, count from the Network IP to the number of available slots.
```
==> Network IP ==> 193.16.20.32
==> Available slots = 7
==> Broadcast IP ==> 193.16.20.38 // The last IP on the netmask
```

4. Find the range of IPs.
```
// With the information we have so far we can deduce that we have a range of 5 address (hosts)
```
==> min host address ==> 193.16.20.33
==> max host address ==> 193.16.20.37
```

The answer to the question would therefore be:
```
Given IP netmask ==> 193.16.20.35/29

==> Network IP ==> 193.16.20.32 // The first IP on the netmask
==> min host address ==> 193.16.20.33
==> max host address ==> 193.16.20.37
==> Broadcast IP ==> 193.16.20.38 // The last IP on the netmask
==> Number of hosts = 5
```



193.16.20.35/29

What is the Network IP, number of hosts, range of IP addresses and broadcast IP from this subnet?

Instruction: Submit all your answer as a markdown file in the folder for this exercise.

