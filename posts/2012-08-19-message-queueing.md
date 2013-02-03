Message queueing

PyMQ
----

LOLWUT?

ZeroMQ
------

Basically a socket; no broker; no persistence.

RabbitMQ
--------

Complete implementation of AMQP, plus extra stuff too. Each exchange is a
separate process in RabbitMQ.

AMQP
----

[AMQP](http://amqp.org) is a standard protocol for message queueing.
Producers, brokers, consumers; exchanges and queues.

Exchanges
---------

Three types of exchanges:

1. Direct exchanges transmit a message with a matching routing key into the
queue it is bound to.

2. Topic exchanges transmit messages with a routing key which matches a
pattern into the queue it is bound to.

3. Fanout exchanges transmit a message to all queues it is bound to.

Mark exchange durable. Mark queues durable. Both need to be durable to connect
to each other. Also: clients need to ask for durable.

Message persistence: set "deliverymode=2" on the message.

Architecture
------------

Have queues on both sides of the cloud, so if the tubes get clogged messages
are stored on either side.

RabbitMQ has a server plugin called Shovel which will forward the messages in
a queue to a queue on another RabbitMQ server. This works around the fact that
you can't connect a queue to a queue.

Configuring it is basically writing an Erlang program.

Web Interface
-------------

Default credentials: guest / guest

Python
------

Piku

Kombu

http://www.tcpcatcher.fr
