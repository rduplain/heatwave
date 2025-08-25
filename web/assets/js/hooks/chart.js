// LiveView for Chart.js
export default {
    mounted() {
        const canvas = this.el.querySelector('canvas') || this.el;
        const ctx = canvas.getContext('2d');

        const config = this.el.dataset.chartConfig
            ? JSON.parse(this.el.dataset.chartConfig)
            : { type: 'line', data: { labels: [], datasets: [] }, options: {} };

        const create = () => {
            if (!window.Chart) {
                setTimeout(create, 50);
                return;
            }
            this.chart = new window.Chart(ctx, config);
        };

        create();

        const debounce = (fn, milliseconds = 120) => {
            let t; // Track in outer scope to clear previous timer.
            return () => {
                clearTimeout(t);
                t = setTimeout(fn, milliseconds);
            };
        };

        this._onWindowResize = debounce(() => {
            if (this.chart && typeof this.chart.resize === 'function') {
                this.chart.resize();
            }
        });

        window.addEventListener('resize', this._onWindowResize);

        this.handleEvent('chart:update', ({ data }) => {
            if (!this.chart) return;
            if (data.labels) this.chart.data.labels = data.labels;
            if (data.datasets) this.chart.data.datasets = data.datasets;
            this.chart.update();
        });
    },

    destroyed() {
        if (this.chart) {
            this.chart.destroy();
            this.chart = null;
        }
        if (this._onWindowResize) {
            window.removeEventListener('resize', this._onWindowResize);
            this._onWindowResize = null;
        }
    }
};
