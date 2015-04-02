dojo.declare('USAIDTracker.ProjectDetailMap', null, {
    constructor: function (args) {
        this.model = {};
        dojo.mixin(this.model, args);
        this.model.mapStyles = this.model.mapStyles || [
          {
            featureType: "poi.park",
            stylers: [
              { visibility: "off" }
            ]
          },{
            featureType: "poi.government",
            elementType: "geometry",
            stylers: [
              { visibility: "off" }
            ]
          },{
            featureType: "landscape.man_made",
            stylers: [
              { visibility: "off" }
            ]
          },{
            featureType: "poi",
            stylers: [
              { visibility: "off" }
            ]
          },{
            featureType: "road",
            stylers: [
              { visibility: "off" }
            ]
          },{
            featureType: "transit",
            stylers: [
              { visibility: "off" }
            ]
          },{
            featureType: "landscape.natural",
            stylers: [
              { hue: "#9900ff" },
              { visibility: "simplified" },
              { invert_lightness: true },
              { saturation: -94 },
              { lightness: 95 }
            ]
          },{
            featureType:"administrative.country",
            elementType:"geometry",
            //stylers: [{ visibility: "on" },{ gamma: 0.25 },{ saturation: -99 },{ lightness: -30 }]
            stylers: [{ visibility: "on" },{ gamma: 0.9 },{ lightness: 65 }]//{ lightness: -30 }
            //stylers:[{visibility:"simplified"},{lightness:0}]
          },{
            featureType:"administrative.country",
            elementType:"labels",
            stylers:[{visibility:"on"}, {lightness: 45}]
          },{
            featureType:"administrative.province",
            elementType:"labels",
            stylers:[{visibility:"on"}]
          },{
            featureType:"administrative.province",
            elementType:"geometry",
            //stylers:[{visibility:"on"},{lightness: -20},{gamma: 0.51},{ hue: "#007fff" }]
            stylers:[{visibility:"simplified"},{lightness: -20}]
          }         
        ];
        if (this.model.bound) {
            var cs = this.model.bound.split(',');
            this.model.bound = new google.maps.LatLngBounds(new google.maps.LatLng(+cs[0]||9,+cs[1]||19), new google.maps.LatLng(+cs[2]||11,+cs[3]||21));
        }
        this.model.options = this.model.options || {
            styles: this.model.mapStyles,
            center: new google.maps.LatLng(10, 20),
            zoom: 2,
            maxZoom: 9,
            mapTypeControl: false,
            panControl: false,
            zoomControl: true,
            overviewMapControl: false,
            streetViewControl: false,
            mapTypeId: google.maps.MapTypeId.ROADMAP
        };
    },
    present: function (context, pos) {
        //this.model.domNode = dojo.create("div", {"class": "projectdetailmap"}, context);
        this.model.map = new google.maps.Map(context, this.model.options);
        this.loadProjectDetailData();
    },
    requestData: function (request, options) {
        var content = options || {};
        content.r = request;
        var jsonpArgs = {
            url: this.model.mapDataUrl,
            callbackParamName: "callback",
            content: content
        };
        return dojo.io.script.get(jsonpArgs).then(function (data) {
            return data;
        }, function (error) {
            return error;
        });
    },
    loadProjectDetailData: function(filterOptions) {
        dojo.when(this.requestData("pd", filterOptions), dojo.hitch(this, function (dataset) {
            if (this.model.debug) { console.debug(dataset); }
            this.showLocations(dataset);
       }));    
    },
    showLocations: function(dataset) {
        //console.debug(dataset); 
        var finalBound = new google.maps.LatLngBounds();
        dojo.forEach(dataset, function(p, i) {
            var myLatlng = new google.maps.LatLng(p.admin1BndryLatitude__c, p.admin1BndryLongitude__c);
            var marker = new google.maps.Marker({
                position: myLatlng,
                map: this.model.map,
                title: p.admin1BndryName__c || '',
                visible: true,
                optimized: true,
                icon: 'http://labs.google.com/ridefinder/images/mm_20_blue.png'//'http://labs.google.com/ridefinder/images/mm_20_green.png';
                // icon: {
                //     path: google.maps.SymbolPath.CIRCLE,
                //     scale: 3,
                //     fillColor: 'yellow',
                //     strokeColor: 'yellow'
                // }
            });
            //if (finalBound) {
            finalBound = finalBound.extend(myLatlng);
            //} else {
            //    finalBound = new google.maps.LatLngBounds( new google.maps.LatLng(myLatlng.lat()-1, myLatlng.lng()-1), new google.maps.LatLng(myLatlng.lat()+1, myLatlng.lng()+1));
            //}            
        }, this);         
        if (finalBound && !finalBound.equals(new google.maps.LatLngBounds())) { 
            this.model.map.fitBounds(finalBound);
        } else {
            this.model.map.fitBounds(this.model.bound);
        }     
    }
});
