<template>
    <div id = 'app_posts'>
        <div class="enother_component1">
            Здесь будет красивая кнопочка для вызова формы с редактором для создания нового поста.

        </div>
        <div class="posts_list_component"><posts-list/></div>
        <div class="enother_component2">qergwergwrgewgrwergwergwergwrgewg</div>
    </div>
</template>

<script>
    import PostsList from './components/PostsList.vue'
    export default {
        methods: {
            get_posts: function() {
                    this.$http.get('/posts').then(function(responce) {
                        console.log(this)
                        return responce.body
                    }, function(error){
                        // error
                    })
            }
        },
        components: {
            'posts-list': PostsList
        }
    }
</script>

<style lang="scss" scoped >
    #app_posts{
        display: flex;
        justify-content: space-between;
    }
    .enother_component1{
        width: 300px;
    }
</style>