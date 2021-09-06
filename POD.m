clear;

% a==b would result in 2 modes
% a!=b would result in 4 modes
a = 1;
b = 1;
npts = 101;
x_arr = linspace(-1,1,npts);
y_arr = linspace(-1,1,npts);
[x_mat, y_mat] = meshgrid(x_arr, y_arr);
uFunc = @(t) sin(2*pi*(x_mat - a*t)) + sin(2*pi*(y_mat - b*t));

nt = 101;
t_arr = linspace(0, 1.0, nt);
u_mat = zeros(npts*npts, nt);
for i = 1:nt
  t = t_arr(i);
  tmp_mat = uFunc(t);
  u_mat(:, i) = reshape(tmp_mat, [npts*npts, 1]);
end

[U,S,V] = svd(u_mat,'econ');

f = figure();
s_arr = diag(S);
s_sum = sum(s_arr);
s_arr = s_arr / s_sum;
plot(s_arr(1:10), 'o');
title_str = sprintf('POD modes distribution');
title(title_str);

n_mode = sum(s_arr>1E-12);
u_modes_mat = zeros(npts*npts,nt,n_mode);
for i = 1:n_mode
  u_modes_mat(:,:,i) = U(:, i) * S(i,i) * V(:, i)';
end

f = figure();
ax_arr = gobjects(n_mode,1);
label_arr = cell(n_mode,1);
for i = 1:n_mode
  ax_arr(i) = plot(t_arr, V(:, i)); hold on;
  label_arr{i} = sprintf('Mode No. %d', i);
end
legend(ax_arr, label_arr);
title_str = sprintf('Time variation of the POD modes');
title(title_str);

f = figure();
h.Visible = 'off';
for it = 1:nt
  ax1 = subplot(2,2,1);
  u_pod = reshape(sum(u_modes_mat(:,it,1:n_mode), 3), [npts, npts]);
  title_str = sprintf('Mode sum(1:%d)',n_mode);
  contourf(x_mat, y_mat, u_pod);
  title(title_str);
  ax2 = subplot(2,2,2);
  contourf(x_mat, y_mat, reshape(u_mat(:,it), [npts, npts]));
  title_str = sprintf('Original solution');
  title(title_str);
  ax3 = subplot(2,2,3);
  contourf(x_mat, y_mat, reshape(u_modes_mat(:,it,1), [npts, npts]));
  title_str = sprintf('Mode no. %d', 1);
  title(title_str);
  ax4 = subplot(2,2,4);
  contourf(x_mat, y_mat, reshape(u_modes_mat(:,it,2), [npts, npts]));
  title_str = sprintf('Mode no. %d', 2);
  title(title_str);
  drawnow
end
h.Visible = 'on';

