document.addEventListener("DOMContentLoaded", function(){
    fetch("/api/locations")
    .then(response=> response.json())
    .then(data => {
        data.forEach(location => {
            var newMarker = new google.maps.Marker({
                position: {lat: location.latitude, lng: laocation.longitude},
                mao:map,
                title:location.name
            });

            var infoWindow = new google.maps.InfoWindow({
                content: "<strong>" + location.name + "</strong><br>" +
                "Description:" + location.description + "<br>" +
                "Mood:" + location.mood + "<br>" +
                "Price:" + location.price
            });
            newMarker.addListener("click", function(){
                infoWindow.open(map,newMarker);
            });
            markers.push({
                marker: newMarker,
                name: location.name,
                description: location.description,
                mood: location.mood,
                price: location.price
            });
        });
    })
    .catch(error => {
        console.error("Error", error);
    });


    fetch("/api/locations",{
        method: "POST",
        headers: {
            "Content type": "application/json"
        },
        body : JSON.stringfly(newLocation)
    })
    .then(response => response.json())
    .then(data => {
        console.log(data);
    })
    .catch(error=> {
        console.error("Error:", error);

    });
    fetch("/api/locations")
    .then(response => response.json())
    .then(data =>{
        console.log(data);
    })
    .catch(error => {
        console.error("error:", error);
    });
    clearForm();

    var newMarker = new google.maps.Marker({
        position: {lat: latitude, lng: longitude},
        map:map,
        title: name
    });
    var infoWindow = new google.maps.InfoWindow({
        content: "<strong>" + name + "</strong><br>" +
        "Description:" + description + "<br>" +
        "Mood:" + mood + "<br>" +
        "Price:" + price

    });
    newMarker.addListener("click", function(){
        infoWindow.open(map, newMarker);
    });

    markers.push({
        marker: newMarker,
        name: name,
        description: description,
        mood: mood,
        price: price
    });
    updatePartyList();
    clearForm();
