import React from 'react';
import Navbar from '../components/Navbar';
import Hero from '../components/Hero';
import Newsletter from '../components/Newsletter';
import Footer from '../components/Footer';
import Features from '../components/Features.jsx';
import FeaturesBlocks from '../components/FeaturesBlocks.jsx';
import { Team } from '../components/Team';
import Trust from '../components/Trust';
import FAQ from '../components/FAQ.jsx';

const Landing = () => {
    return (
        <>
            <Navbar />
            <Hero />
            <Features />
            <FeaturesBlocks />
            <Team />
            <Trust />
            <FAQ />
            <Newsletter />
            <Footer />
        </>
    );
};

export default Landing;
