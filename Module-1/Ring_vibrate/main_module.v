module R_V(
    input ring,
    input vibrate_mode,
    output ringer,       // Make sound
    output motor         // Vibrate
);
    assign ringer = (ring & ~vibrate_mode );
    assign motor =  (ring & vibrate_mode ) ;
     

endmodule
