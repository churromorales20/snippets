<template>
  <transition name="fade">
    <div v-if="checkStep == 2">
      <transition name="fade" @after-leave="localIsUserAuthenticated = true">
        <div v-if="!shopping.isUserAuthenticated">
          <transition name="fade" @after-leave="currentlyShowing = willShow">
            <CommonsShoppingUserForm v-if="currentlyShowing == 'new_user_form'" />
          </transition>
          <transition name="fade" @after-leave="currentlyShowing = willShow">
            <CommonsShoppingUserLoginForm 
              @user-logged="(resul) => {
                
                shopping.checkAuthuser();
                localIsUserAuthenticated = false
              }"
              v-if="currentlyShowing == 'existent_user_form'" 
            />
          </transition>
          <CommonsShoppingUserExistent 
            @view-changed="(view) => {
              currentlyShowing = ''
              willShow = view
            }" 
          />
        </div>
      </transition>
      <transition name="fade">
        <CommonsShoppingUserLogged 
          @user-changed="localIsUserAuthenticated = false" 
          v-if="localIsUserAuthenticated" 
        />
      </transition>
    </div>
  </transition>
  <transition name="fade" @after-leave="checkStep = 2">
    <div v-if="checkStep == 1">
      <h2 class="text-lg font-semibold pb-3 border-b border-gray-300 mb-4">{{ $t('shopping.user_info') }}</h2>
      <div class="flex border-b border-gray-200 pb-2 items-center mb-4 pb-4">
        <USkeleton :ui="uiOptions" class="h-14 w-14 mr-4" />
        <div class="space-y-2 w-5/6">
          <USkeleton :ui="uiOptions" class="h-3 w-full" />
          <USkeleton :ui="uiOptions" class="h-3 w-full" />
          <USkeleton :ui="uiOptions" class="h-3 w-5/6" />
        </div>
      </div>
      <div class="text-gray-700 mb-2 text-sm space-y-2">
        <USkeleton :ui="uiOptions" class="h-3 w-full" />
        <USkeleton :ui="uiOptions" class="h-3 w-5/6" />
        <USkeleton :ui="uiOptions" class="h-3 w-4/6" />
        <USkeleton :ui="uiOptions" class="h-3 w-4/6" />
      </div>
    </div>
  </transition>
</template>

<script setup>
import { onMounted } from 'vue';

const uiOptions = ref({
  background: 'bg-cool-300',
  rounded: 'rounded-full'
})

const currentlyShowing = ref('new_user_form')
const shopping = shoppingStore();
const checkStep = ref(1)
const willShow = ref('')
const localIsUserAuthenticated = ref(false)

onMounted(() => {
  shopping.checkAuthuser();
  localIsUserAuthenticated.value = shopping.isUserAuthenticated;
  checkStep.value = 0;
});
</script>

<style scoped>
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.5s;
}

.fade-enter,
.fade-leave-to {
  opacity: 0;
}
</style>
