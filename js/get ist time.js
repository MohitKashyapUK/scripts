function IST_date() {
    const date = new Date(new Date().toUTCString());

    return date.toLocaleString('en-IN', { timeZone: 'IST' });
}
