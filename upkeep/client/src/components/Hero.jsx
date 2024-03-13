import React from 'react';

const Hero = () => {
    return (
        <div className="bg-gradient-to-b from-[#00df9a] to-[#009c74] text-white">
            <div className="max-w-[800px] mt-[-96px] w-full h-screen mx-auto text-center flex flex-col justify-center">
                <p className="text-lg md:text-xl font-bold p-2">
                    FROM TRUSTED VENDORS
                </p>
                <h1 className="md:text-6xl sm:text-5xl text-3xl font-bold md:py-6">
                    Hassle-Free Service
                </h1>
                <div className="flex justify-center items-center">
                    <p className="md:text-4xl sm:text-3xl text-lg font-bold py-4">
                        Connect, Collaborate,
                    </p>
                    {/* You can add more lines here if needed */}
                </div>
                <p className="md:text-lg text-base font-bold text-gray-200">
                    Your one-stop-shop for all your service needs
                </p>
                <button className="bg-white text-[#00df9a] w-[200px] rounded-md font-medium my-6 mx-auto py-3">
                    Get started for free
                </button>
            </div>
        </div>
    );
};

export default Hero;
