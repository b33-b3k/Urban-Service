import { Router } from 'express';
import {
    createService,
    getServices,
    getService,
    getSingleService,
    getCategory,
    getUsersForService,
} from '../controllers/service.controller.js';
import { useLogin, verifyVendor } from '../middlewares/auth.js';
import { upload } from '../middlewares/uploadImage.js';
// import { uploadImageMiddleware } from '../middlewares/uploadImage.js';

const serviceRouter = Router();

serviceRouter.post(
    '/',
    useLogin,
    verifyVendor,
    upload.array('images', 10),
    createService,
);

serviceRouter.get('/', getServices);
serviceRouter.get('/single', getSingleService);
serviceRouter.get('/single', getService);
serviceRouter.get('/category', getCategory);
serviceRouter.get('/user/:id', getUsersForService);

export default serviceRouter;
