import mongoose from 'mongoose';

export const connectDB = async () => {
  try {
    await mongoose.connect(process.env.mongodb+srv://Admin:Admin%4012345@cluster0.czllghf.mongodb.net/myDatabase?retryWrites=true&w=majority);
    console.log('✅ MongoDB සම්බන්ධ විය');
  } catch (err) {
    console.error('❌ MongoDB සම්බන්ධ වීම අසාර්ථකයි:', err.message);
    process.exit(1);
  }
};

