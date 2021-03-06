function software_register_init(io_dir, arith_type, bitwidth, bin_pt, sample_period, gw_name, latency)

if strcmp(io_dir, 'To Processor')
    to_sim = xOutport('sim_reg_out');
    to_proc = xInport('reg_out');
    
    convert_out1 = xSignal;
    convert = xBlock(struct('source', 'Convert', 'name', 'convert'), ...
                            struct('arith_type', arith_type, ...
                                   'n_bits', 32, ...
                                   'bin_pt', bin_pt), ...
                            {to_proc}, ...
                            {convert_out1});

    untitled_sync_period_user_data_in = xBlock(struct('source', 'Gateway Out', 'name', [gw_name, '_user_data_in']), ...
                                                      [], ...
                                                      {convert_out1}, ...
                                                      {to_sim});
elseif strcmp(io_dir, 'From Processor')
    sim_reg_in = xInport('sim_reg_in');
    reg_in = xOutport('reg_in');
    data_in = xSignal;
    user_data_out = xBlock(struct('source', 'Gateway In', 'name', [gw_name, '_user_data_out']), ...
                            struct('period', sample_period, 'n_bits', 32, 'bin_pt', bin_pt, 'arith_type', arith_type), ...
                            {sim_reg_in}, {data_in});
                        
    delay_pipeline_config.source = str2func('pipeline_init_xblock');
    delay_pipeline_config.name = 'delay_pipe';
    delay_pipeline = xBlock( delay_pipeline_config, {latency}, {data_in}, {reg_in} );
end

end

