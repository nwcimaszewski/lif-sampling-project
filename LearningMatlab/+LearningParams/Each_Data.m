% Computations for each k in loss function summation : E[\sum_k log p(z_hidden,data)/q(z_hidden|data)]
function [gr_G,gr_sig,gr_pr,G_vb_avg,s_vb_avg,pr_vb_avg,norm_wt] = Each_Data(params,stim,mu)
gr_G = zeros(params.pix^2,params.Neurons_hidden);
gr_sig = 0;
gr_pr = 0;
N = params.Neurons_hidden;
G_vb_avg = 0;
s_vb_avg = 0;
pr_vb_avg = 0;
w_hidden = zeros(1,params.K_samples);
for k = 1:params.K_samples
    z_hidden = binornd(1,transpose(mu), N,1);
    w_hidden(k) = LearningParams.prob(params,stim,z_hidden)/LearningParams.q_compute(params,z_hidden,mu);
    [G,s,pr,G_vb, s_vb, pr_vb] = LearningParams.compute_gradients_elbo(params,mu,stim,z_hidden);
    gr_G = gr_G + G * w_hidden(k);
    gr_sig = gr_sig + s * w_hidden(k);
    gr_pr = gr_pr + pr * w_hidden(k);
    G_vb_avg = G_vb_avg + G_vb;
    s_vb_avg = s_vb_avg + s_vb;
    pr_vb_avg = pr_vb_avg + pr_vb;
    
end
norm_wt = sum(w_hidden);
G_vb_avg = G_vb_avg / params.K_samples;
s_vb_avg = s_vb_avg / params.K_samples;
pr_vb_avg = pr_vb_avg / params.K_samples;

end