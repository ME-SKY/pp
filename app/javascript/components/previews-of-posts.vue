<template>
    <div class="all_previews">

        <div class="first_row_all_previews">

            <div v-for="preview in all_previews" class="one_preview">
                <post-preview :description_image="preview.description_image" ></post-preview>
            </div>
        </div>

        <div class="second_row_all_previews">

            <div v-for="preview in all_previews" class="one_preview">
                <post-preview :description_image="preview.description_image" ></post-preview>
            </div>
        </div>

        <div class="third_row_all_previews">

            <div v-for="preview in all_previews" class="one_preview">
                <post-preview :description_image="preview.description_image" ></post-preview>
            </div>
        </div>

        <div class="fourth_row_all_previews">

            <div v-for="preview in all_previews" class="one_preview">
                <post-preview :description_image="preview.description_image" ></post-preview>
            </div>
        </div>
    </div>
</template>

<script>
    import PostPreview from './post-preview'

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
        methods: {
            get_posts: function(){
                this.$http.get('/posts', {give_me_previews: 'yes'}).then(function(responce) {
                    this.all_previews = responce.body
                }, function(error){
                    console.log('error')
                })
            }
        },
        created: function() {
            this.get_posts()
        },
        mounted: function(){
            var vc = this
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

    .all_previews{
        display: flex;
        flex-direction: column;
    }

    .first_row_all_previews{
        display: flex;
        flex-direction: row;
        align-items: center;
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

</style>