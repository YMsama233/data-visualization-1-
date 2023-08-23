<template>
    <div></div>
</template>
<style>canvas{width:100%;height:100%}</style>
<script setup>
    import * as THREE from 'three';
    import {OrbitControls} from 'three/examples/jsm/controls/OrbitControls'
    var scene = new THREE.Scene()
    var camera = new THREE.PerspectiveCamera(75,window.innerWidth/window.innerHeight, 0.1, 1000)
    var renderer = new THREE.WebGLRenderer();
    

    var beijing=[{date:'6月11',totle:300,add:30},
    {date:'6月12',totle:310,add:31},
    {date:'6月13',totle:330,add:33},
    {date:'6月14',totle:360,add:36},
    {date:'6月15',totle:340,add:34},
    {date:'6月16',totle:360,add:36},
    {date:'6月17',totle:350,add:35},
    {date:'6月18',totle:350,add:35},
    {date:'6月19',totle:300,add:30},
    {date:'6月20',totle:370,add:37},
    {date:'6月21',totle:380,add:38},
    {date:'6月22',totle:380,add:38},
    {date:'6月23',totle:380,add:38},
    {date:'6月24',totle:380,add:38},
    {date:'6月25',totle:380,add:35},]

    

    renderer.setSize(window.innerWidth, window.innerHeight);
    document.body.appendChild(renderer.domElement);

    const controls =  new OrbitControls(camera,renderer.domElement);
	controls.minDistance = 100;
	controls.maxDistance = 900;

    camera.position.z=150;
    camera.position.y=100;
    camera.position.x=50;

    // 创建一个网格辅助线对象
    const gridHelper = new THREE.GridHelper(1000, 10);
    scene.add(gridHelper);

    // camera.lookAt({x:60,y:100,z:-100})

    var Sphere = new Array(15)
    var light = new THREE.PointLight(0xffff00);
    light.position.set(-20, 200, 100);

    light.intensity = 2;


    for(var i=0;i<15;i++){    
        var geometry = new THREE.SphereGeometry(beijing[i].totle/50, 10, 10);
        var material = new THREE.MeshPhongMaterial({
            wireframe:false,
            color: 'rgb('+(255-(38-beijing[i].add)*10)+','+(40*(38-beijing[i].add))+',0)'
        });
        Sphere[i] = new THREE.Mesh(geometry, material);
        Sphere[i].position.set(-150+i*20, beijing[i].add*5/2-50, 0);

        scene.add(Sphere[i]);
    }
    scene.add(light);

    function render(){
        requestAnimationFrame(render);
        renderer.render(scene , camera);
        controls.update();
    }
    render();

</script>
