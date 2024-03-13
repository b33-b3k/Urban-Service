import React from 'react';

export const Team = () => {
    return (
        <>
            <div className="bg-white px-40 py-24 sm:py-32">
                <div className="ml-[400px] grid max-w-7xl gap-y-20 gap-x-8 px-6 lg:px-8 xl:grid-cols-3">
                    <div className="max-w-2xl ml-10">
                        <h2 className="text-3xl font-bold tracking-tight text-gray-900 sm:text-4xl">
                            Meet Our Developer
                        </h2>
                        <p className="mt-6 text-lg leading-8 text-gray-600">
                            Backend developer at AITC Kathmandu.
                        </p>
                    </div>

                    <div className="ml-16">
                        <img
                            className="h-16 w-16 rounded-full"
                            src="https://images.unsplash.com/photo-1607990281513-2c110a25bd8c?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=934&q=80"
                            alt=""
                        />
                        <div>
                            <h3 className="text-base font-semibold leading-7 tracking-tight text-gray-900">
                                Sudip Kumar Mahato X Komal Tamang
                            </h3>
                            <p className="text-md font-semibold leading-6 text-green-600">
                                Founder | Backend Developer
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </>
    );
};
