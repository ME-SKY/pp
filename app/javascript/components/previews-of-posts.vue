<template>
    <div class="all_previews">

        <div class="first_row_all_previews" >

            <div v-for="preview in all_previews" class="one_preview" >

                <!--<transition-group tag="div" name="slide_left">-->
                    <div class="animation_block" :key="preview.description_image" @click="buum">

                        <post-preview :description_image="preview.description_image" ></post-preview>
                    </div>
            </div>
        </div>

        <div class="second_row_all_previews">

            <div v-for="preview in all_previews_reversed" class="one_preview" >

                <!--<transition-group tag="div" name="slide_right">-->
                    <div class="animation_block" :key="preview.description_image" >

                        <post-preview :description_image="preview.description_image" ></post-preview>
                    </div>
                <!--</transition-group>-->
            </div>
        </div>

        <div class="third_row_all_previews">

            <div v-for="preview in all_previews" class="one_preview">

                <!--<transition-group tag="div" name="slide_left">-->
                    <div class="animation_block" :key="preview.description_image" @click="buum">

                        <post-preview :description_image="preview.description_image"></post-preview>
                    </div>
                <!--</transition-group>-->
            </div>
        </div>

        <div class="fourth_row_all_previews">

            <div v-for="preview in all_previews_reversed" class="one_preview">

                <!--<transition-group tag="div" name="slide_right">-->
                    <div class="animation_block" :key="preview.description_image" @click="buum">

                        <post-preview :description_image="preview.description_image" ></post-preview>
                    </div>
                <!--</transition-group>-->
            </div>
        </div>
    </div>
</template>

<script>
    import PostPreview from './post-preview'
    import 'velocity-animate'
    // import { Velocity } from 'velocity-animate'
    import Velocity from 'velocity-animate';

    export default {
        name: "previews-of-posts",
        components:{
            'post-preview': PostPreview
        },
        data: function(){
            return {
                all_previews: []
            }
        },
        computed: {
            all_previews_reversed: function(){
                return this.all_previews.reverse()
            }
        },
        methods: {
            get_previews: function(){
                this.$http.get('/posts?get_previews=true').then(function(responce) {
                    this.all_previews = responce.body
                    Window.preview_list = this.all_previews
                }, function(error){
                    console.log('error')
                })
            },
            buum: function(e){
                e.target.animate({marginLeft: '100%' }, 1000)
                console.log('buum')
                // e.target.style.position = 'relative'
                // // e.target.velocity({rotateZ: '50deg'},{ duration: 500})
                // let translateX  = Velocity.hook(e.target, 'translateX')
                // console.log(`Velocity.hook. rotateZ is: ${translateX}`)
                // let translateXValue = parseInt(translateX) + 90
                // console.log(`rotateValue: ${translateXValue}`)
                //
                // // Velocity(e.target, { rotateZ: `${rotateValue}deg` }, { duration: 100 })
                // Velocity(e.target, {translateX: `${translateXValue}px`}, { duration: 600 })
                // Velocity(e.target, {transform:"translateX(200px)"}, { duration: 600 })
                // e.target.velocity({ translateX: '15px', rotateZ: '50deg' }, { duration: 600 })
                // Velocity.hook(e.target, )

            }
        },
        created: function() {
            this.get_previews()
        },
        mounted: function(){
            // Window.preview_list = this.previ
            let all_animation_blocks = document.querySelectorAll('.one_preview')
            var vc = this

            // all_animation_blocks.forEach(function(el){
            //     el.animate({marginLeft: '100%' }, 1000)
                // Velocity(el, { animation: 'slow_sliding 50s infinite alternate linear', animation_direction: 'alternate'})
            // })


            // Velocity(all_animation_blocks, { animation: 'slow_sliding 6s alternate infinite linear'})

            // all_animation



            // vc.$root.$on('newPostIsCreated', function (post) {
            //     console.log('new post is created!!!')
            //     console.log(post)
                console.log(vc.all_previews)
                // vc.all_previews.unshift(post)
            // })
        }
    }
</script>

<style lang="scss">
    
    @keyframes slow_sliding {
        0% {
            transform: translate(0, 0) ;

        }
        100% {
            transform: translate(85%, 0);

        }
    }

    /*@keyframes rotating {*/
        /* 0%{-->*/
            /*transform: rotate(0deg);*/
        /*}*/
        /**/
        /*100%{*/
            /*transform: rotate(320deg);*/
        /*}*/
    /*}*/

    .all_previews{
        display: flex;
        flex-direction: column;
    }

    .first_row_all_previews{
        transform-origin: 100%;
        display: flex;
        flex-direction: row;
        align-items: center;
        /*will-change: margin-left;*/
        overflow: hidden;
        animation: slow_sliding 1600s infinite alternate linear;
        margin-right: auto;
        padding: auto;
    }

    .second_row_all_previews{
        display: flex;
        flex-direction: row-reverse;
        align-items: center;

        img{
            transform: scale(-1, 1)
        }
    }

    .third_row_all_previews{
        display: flex;
        flex-direction: row;
        align-items: center;
    }

    .fourth_row_all_previews{
        display: flex;
        flex-direction: row-reverse;
        align-items: center;

        img{
            transform: scale(-1, 1)
        }
    }

    /*.slide_left-move {*/
        /*transform: rotateX(150deg);*/
        /*transition: transform 1s;*/
    /*}*/

    /*.slide_left-enter, .slide_left-leave-to{*/
        /*transform: translateX(10px);*/
        /*opacity: 0;*/
    /*}*/

</style>