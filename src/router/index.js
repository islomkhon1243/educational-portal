import Vue from 'vue';
import Router from 'vue-router';
import HomePage from '../components/HomePage.vue';
import Login from '../components/LoginPage.vue';
import Register from '../components/RegisterPage.vue';
import Universities from '../components/UniversitiesPage.vue';
import UniversityDetails from "@/components/UniversityDetails.vue";
import LogoutPage from "@/components/LogoutPage.vue";
import CalendarPage from "@/components/CalendarPage.vue";
import UserDashboard from "@/components/UserDashboard.vue";
import ArticlesPage from "@/components/ArticlesPage.vue";
import AdminUniversities from "@/components/AdminUniversities.vue";
import RIASECTest from "@/components/RIASECTest.vue"; // Assuming this component exists

Vue.use(Router);

const isAuthenticated = () => {
  return !!localStorage.getItem('userId'); // Check if token exists
};

const router = new Router({
  mode: 'history',
  routes: [
    {
      path: '/',
      name: 'HomePage',
      component: HomePage,
    },
    {
      path: '/login',
      name: 'Login',
      component: Login,
    },
    {
      path: '/logout',
      name: 'logout',
      component: LogoutPage,
    },
    {
      path: '/register',
      name: 'Register',
      component: Register,
    },
    {
      path: '/universities',
      name: 'Universities',
      component: Universities,
    },
    {
      path: '/universities/:id',
      name: 'UniversityDetails',
      component: UniversityDetails,
    },
    {
      path: '/calendar',
      name: 'CalendarPage',
      component: CalendarPage,
    },
    {
      path: '/articles',
      name: 'ArticlesPage',
      component: ArticlesPage,
    },
    {
      path: '/dashboard',
      name: 'UserDashboard',
      component: UserDashboard,
    },
    {
      path: '/proftest',
      name: 'RIASECTest',
      component: RIASECTest,
    },
    {
      path: '/admin/universities',
      name: 'AdminUniversities',
      component: AdminUniversities,
    },
  ],
});

router.beforeEach((to, from, next) => {
  if (to.name === 'UniversitiesPage' && !isAuthenticated()) {
    next({ name: 'HomePage' }); // Redirect to HomePage if not authenticated
  } else {
    next();
  }
});

export default router;