package com.stacksimplify.restservices.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import com.stacksimplify.restservices.services.CustomUserDetailsService;
import org.springframework.security.config.Customizer;  // Import for withDefaults()

@Configuration
@EnableMethodSecurity(prePostEnabled = true)  // Replace with @EnableMethodSecurity
public class SecurityConfigWeb {

    // BCrypt Password Encoder Bean
    @Bean
    public BCryptPasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    // Custom UserDetailsService Bean
    @Bean
    public UserDetailsService userDetailsService() {
        return new CustomUserDetailsService();
    }

    // AuthenticationManager Bean without using deprecated `and()`
    @Bean
    public AuthenticationManager authenticationManager(HttpSecurity http, BCryptPasswordEncoder passwordEncoder, UserDetailsService userDetailsService) 
        throws Exception {
        AuthenticationManagerBuilder authBuilder = http.getSharedObject(AuthenticationManagerBuilder.class);
        authBuilder.userDetailsService(userDetailsService).passwordEncoder(passwordEncoder);
        return authBuilder.build();
    }

    // Security Filter Chain Bean
    
    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        // Disable CSRF for testing purposes using the new approach
        http.csrf(csrf -> csrf.disable());

        // Disable frame options to allow H2 console access
        http.headers(headers -> headers.frameOptions(frameOptions -> frameOptions.disable()));

        // Security configurations for URL patterns
        http
        .authorizeHttpRequests(auth -> auth
            .requestMatchers("/login", "/h2-console/**", "/hello1", "/helloworld-bean", "/helloworld1", "/health", "/actuator/health").permitAll()  // Allow public access
            .anyRequest().authenticated()
        )
        .formLogin(form -> form
            .defaultSuccessUrl("/", true)  // Redirect to welcome.jsp after successful login
            .permitAll() // Allow all users to access the login page
        )
        .logout(logout -> logout
            .logoutUrl("/logout")
            .logoutSuccessUrl("/login?logout")
            .permitAll()
        )
        .requestCache(requestCache -> requestCache.disable()); // Disable saving of the original request to avoid `?continue`


        return http.build();
    }
    




}
