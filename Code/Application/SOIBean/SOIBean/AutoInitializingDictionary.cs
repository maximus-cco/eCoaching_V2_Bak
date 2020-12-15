using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SOIBean
{
    public class AutoInitializingDictionary<K, V> : IDictionary<K,V>
    {
        public Func<K, V> Initializer { get; set; }
        private Dictionary<K,V> Aid { get; }

        private void CheckKey(K key)
        {
            if (!Aid.ContainsKey(key))
                Aid.Add(key, Initializer(key));
        }

        public AutoInitializingDictionary(Func<K, V> initializer) : base()
        {
            Initializer = initializer;
            Aid = new Dictionary<K, V>();
        }

        public AutoInitializingDictionary() : base()
        {
            Aid = new Dictionary<K, V>();
        }

        public ICollection<K> Keys
        {
            get
            {
                return ((IDictionary<K, V>)Aid).Keys;
            }
        }

        public ICollection<V> Values
        {
            get
            {
                return ((IDictionary<K, V>)Aid).Values;
            }
        }

        public int Count
        {
            get
            {
                return ((IDictionary<K, V>)Aid).Count;
            }
        }

        public bool IsReadOnly
        {
            get
            {
                return ((IDictionary<K, V>)Aid).IsReadOnly;
            }
        }

        public V this[K key]
        {
            get
            {
                CheckKey(key);
                return ((IDictionary<K, V>)Aid)[key];
            }

            set
            {
                ((IDictionary<K, V>)Aid)[key] = value;
            }
        }

        public bool ContainsKey(K key)
        {
            return ((IDictionary<K, V>)Aid).ContainsKey(key);
        }

        public void Add(K key, V value)
        {
            ((IDictionary<K, V>)Aid).Add(key, value);
        }

        public bool Remove(K key)
        {
            return ((IDictionary<K, V>)Aid).Remove(key);
        }

        public bool TryGetValue(K key, out V value)
        {
            return ((IDictionary<K, V>)Aid).TryGetValue(key, out value);
        }

        public void Add(KeyValuePair<K, V> item)
        {
            ((IDictionary<K, V>)Aid).Add(item);
        }

        public void Clear()
        {
            ((IDictionary<K, V>)Aid).Clear();
        }

        public bool Contains(KeyValuePair<K, V> item)
        {
            return ((IDictionary<K, V>)Aid).Contains(item);
        }

        public void CopyTo(KeyValuePair<K, V>[] array, int arrayIndex)
        {
            ((IDictionary<K, V>)Aid).CopyTo(array, arrayIndex);
        }

        public bool Remove(KeyValuePair<K, V> item)
        {
            return ((IDictionary<K, V>)Aid).Remove(item);
        }

        public IEnumerator<KeyValuePair<K, V>> GetEnumerator()
        {
            return ((IDictionary<K, V>)Aid).GetEnumerator();
        }

        IEnumerator IEnumerable.GetEnumerator()
        {
            return ((IDictionary<K, V>)Aid).GetEnumerator();
        }
    }
}
