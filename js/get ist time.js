function IST_date() {
    const date = new Date();

    return date.toLocaleString('en-IN', { timeZone: 'IST' });
}
