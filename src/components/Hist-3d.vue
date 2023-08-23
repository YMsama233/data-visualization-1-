<template>
    <div id="bar-chart-container"></div>
</template>

<script>
import { defineComponent} from 'vue';

import * as THREE from "three"





export default defineComponent({
    mounted(){
        this.drawBarChart();
    },
    methods:{
        drawBarChart(){
            var data=[{date:'6月15',totle:673,add:28},{date:'6月14',totle:645,add:44},{date:'6月13',totle:601,add:4},{date:'6月12',totle:597,add:2},{date:'6月11',totle:595,add:1},{date:'6月11',totle:594,add:0}];

            var scene = new THREE.Scene()
            var camera = new THREE.PerspectiveCamera(75,window.innerWidth/window.innerHeight, 0.1, 1000)
            var renderer = new THREE.WebGLRenderer();

            camera.position.z = 5;
            renderer.setSize(window.innerWidth, window.innerHeight);
            document.body.appendChild(renderer.domElement);

            var cylinder=new Array(6);

            for(var i=0;i<6;i++){
                var geometry3=new THREE.CylinderGeometry(20,20,data[i].add*5,20)
                var material3=new THREE.MeshPhongMaterial({
                    wireframe:true,
                    color:'rgb(255,255,255)',
                    specular:0x4488ee,
                    shininess:12
                });
                cylinder[i]=new THREE.Mesh(geometry3,material3);
                cylinder[i].position.set(-100+i*50,data[i].add*5/2,0)
                scene.add(cylinder[i])
            } 
            function render(){
                requestAnimationFrame(render);
                renderer.render(scene,camera);
            }
            render();
        }

    }
})

</Script>