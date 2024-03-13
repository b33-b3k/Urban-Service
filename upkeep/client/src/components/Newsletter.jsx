import React from 'react';

const Newsletter = () => {
    return (
        <div className="h-[400px] bg-slate-100 flex items-center justify-center flex-col">
            <h1 className="text-5xl font-bold mb-5">Newsletter</h1>
            <div className="text-2xl font-light mb-5">
                Get timely updates for latest products and services.
            </div>
            <div className="w-1/2 h-12 bg-white flex justify-between items-center">
                <input
                    className="flex-1 px-4 outline-none"
                    type="text"
                    placeholder="Enter Your Email"
                />
                <button className="bg-green-500 text-white px-4 py-3 hover:bg-red-500">
                    Subscribe
                </button>
            </div>
        </div>
    );
};

export default Newsletter;
