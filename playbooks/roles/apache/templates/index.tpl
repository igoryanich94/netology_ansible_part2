<html>
<head> Processor</head>
<h1> {{ ansible_processor }} </h1>

<head> Memory </head>
<h1> {{ ansible_memtotal_mb }} </h1>

<head> First disk driver</head>
<h1> {{ ansible_devices.sda.size }} </h1>

</html>