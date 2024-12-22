function IST_date() {
    const options = {
        timeZone: 'IST',
        year: '2-digit',
        month: '2-digit',
        day: '2-digit',
        hour: '2-digit',
        minute: '2-digit',
        second: '2-digit',
        hour12: false
    };
    const ist_date = new Date(new Date().toLocaleString('en-US', options));

    return ist_date;
}
